Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaJFFUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:20:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:60692 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbaJFFUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:20:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,662,1406617200"; 
   d="scan'208";a="482167901"
Date: Mon, 6 Oct 2014 13:20:27 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Amir Vadai <amirv@mellanox.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
        Jenkins Builder <jenkins@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [fentry] WARNING: CPU: 0 PID: 1 at
 kernel/trace/trace_functions_graph.c:224
 ftrace_return_to_handler+0xd2/0x1a8()
Message-ID: <20141006052027.GB28732@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

git://flatbed.openfabrics.org/~amirv/linux.git for-netdev
commit de89e9380c82b0da22a6609f973dd6e9d67656e3 ("regression: Disable FENTRY")


+-----------------------------------------------------------------------------+------------+------------+
|                                                                             | d068b02cfd | de89e9380c |
+-----------------------------------------------------------------------------+------------+------------+
| boot_successes                                                              | 0          | 0          |
| boot_failures                                                               | 10         | 10         |
| BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/mutex.c | 7          |            |
| backtrace:do_vfs_ioctl                                                      | 7          |            |
| backtrace:SyS_ioctl                                                         | 7          |            |
| Out_of_memory:Kill_process                                                  | 3          |            |
| Kernel_panic-not_syncing:Out_of_memory_and_no_killable_processes            | 2          |            |
| backtrace:do_execve                                                         | 2          |            |
| backtrace:SyS_execve                                                        | 2          |            |
| backtrace:do_fork                                                           | 3          |            |
| backtrace:SyS_clone                                                         | 3          |            |
| backtrace:do_sys_open                                                       | 1          |            |
| backtrace:SyS_open                                                          | 1          |            |
| backtrace:pgd_alloc                                                         | 1          |            |
| backtrace:mm_init                                                           | 1          |            |
| backtrace:SYSC_reboot                                                       | 1          |            |
| backtrace:SyS_reboot                                                        | 1          |            |
| WARNING:at_kernel/trace/trace_functions_graph.c:ftrace_return_to_handler()  | 0          | 10         |
| backtrace:register_tracer                                                   | 0          | 10         |
| backtrace:init_graph_trace                                                  | 0          | 10         |
| backtrace:kernel_init_freeable                                              | 0          | 10         |
+-----------------------------------------------------------------------------+------------+------------+


[   10.644181] PASSED
[   10.644938] Testing tracer function_graph: 
[   11.136016] ------------[ cut here ]------------
[   11.140000] WARNING: CPU: 0 PID: 1 at kernel/trace/trace_functions_graph.c:224 ftrace_return_to_handler+0xd2/0x1a8()
[   11.140000] Bad frame pointer: expected ffff880023603eb8, received ffff880023603ef0
[   11.140000]   from func __calc_delta return to ffffffff810e981c
[   11.140000] Modules linked in:
[   11.140000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc7-01516-g8585242 #920
[   11.140000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   11.140000]  0000000000000000 ffff880023603db8 ffffffff82d0d960 ffff880023603e00
[   11.140000]  ffff880023603df0 ffffffff810c3476 ffffffff81164abb ffffffff82d05448
[   11.140000]  ffff8800237d6238 ffff8800237d6180 0000000000000000 ffff880023603e58
[   11.140000] Call Trace:
[   11.140000]  <IRQ>  [<ffffffff82d0d960>] dump_stack+0x4d/0x66
[   11.140000]  [<ffffffff810c3476>] warn_slowpath_common+0x7f/0x98
[   11.140000]  [<ffffffff81164abb>] ? ftrace_return_to_handler+0xd2/0x1a8
[   11.140000]  [<ffffffff82d05448>] ? set_tsk_thread_flag+0x13/0x13
[   11.140000]  [<ffffffff810c34d7>] warn_slowpath_fmt+0x48/0x50
[   11.140000]  [<ffffffff810e9461>] ? __calc_delta+0x15/0xae
[   11.140000]  [<ffffffff81164abb>] ftrace_return_to_handler+0xd2/0x1a8
[   11.140000]  [<ffffffff810e981c>] ? sched_slice+0x74/0x87
[   11.140000]  [<ffffffff82d3485e>] ? ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff810e981c>] sched_slice+0x74/0x87
[   11.140000]  [<ffffffff810e981c>] ? sched_slice+0x74/0x87
[   11.140000]  [<ffffffff82d34873>] return_to_handler+0x15/0x32
[   11.140000]  [<ffffffff82d3485e>] ? ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff810ebe79>] task_tick_fair+0x88/0x109
[   11.140000]  [<ffffffff8107a7e3>] ? ftrace_write+0x23/0x4c
[   11.140000]  [<ffffffff82d3485e>] ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff810e54be>] scheduler_tick+0x57/0x89
[   11.140000]  [<ffffffff82d3485e>] ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff811195c8>] update_process_times+0x56/0x65
[   11.140000]  [<ffffffff82d3485e>] ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff811240dd>] tick_periodic+0xa1/0xad
[   11.140000]  [<ffffffff82d3485e>] ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff8112427d>] tick_handle_periodic+0x26/0x60
[   11.140000]  [<ffffffff81089300>] ? __virt_addr_valid+0x66/0x8d
[   11.140000]  [<ffffffff82d3485e>] ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff8107556a>] local_apic_timer_interrupt+0x54/0x57
[   11.140000]  [<ffffffff82d3485e>] ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff82d3501d>] smp_apic_timer_interrupt+0x2b/0x3c
[   11.140000]  [<ffffffff82d33082>] apic_timer_interrupt+0x72/0x80
[   11.140000]  <EOI>  [<ffffffff81080ac3>] ? pvclock_clocksource_read+0x76/0xa0
[   11.140000]  [<ffffffff81164d97>] ? trace_graph_entry+0x175/0x18b
[   11.140000]  [<ffffffff8108937b>] ? __phys_addr_symbol+0x4/0x24
[   11.140000]  [<ffffffff8107ff56>] kvm_clock_read+0x27/0x31
[   11.140000]  [<ffffffff81051ebc>] paravirt_sched_clock+0x9/0xd
[   11.140000]  [<ffffffff81052506>] sched_clock+0x9/0xb
[   11.140000]  [<ffffffff8114fda6>] trace_clock_local+0x11/0x1b
[   11.140000]  [<ffffffff81164916>] ftrace_push_return_trace+0x76/0x149
[   11.140000]  [<ffffffff8107a7e3>] ? ftrace_write+0x23/0x4c
[   11.140000]  [<ffffffff8108937b>] ? __phys_addr_symbol+0x4/0x24
[   11.140000]  [<ffffffff8107af30>] prepare_ftrace_return+0xa2/0xb5
[   11.140000]  [<ffffffff8108937b>] ? __phys_addr_symbol+0x4/0x24
[   11.140000]  [<ffffffff82d34833>] ftrace_graph_caller+0x53/0x7e
[   11.140000]  [<ffffffff810f9873>] ? trace_hardirqs_on_caller+0x18f/0x1ab
[   11.140000]  [<ffffffff81164f4a>] ? trace_graph_return+0x8e/0x97
[   11.140000]  [<ffffffff8107a7e3>] ? ftrace_write+0x23/0x4c
[   11.140000]  [<ffffffff811420f6>] ? audit_find_rule+0x12/0x108
[   11.140000]  [<ffffffff811420f1>] ? audit_find_rule+0xd/0x108
[   11.140000]  [<ffffffff81089380>] ? __phys_addr_symbol+0x9/0x24
[   11.140000]  [<ffffffff81089380>] ? __phys_addr_symbol+0x9/0x24
[   11.140000]  [<ffffffff82d3485e>] ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff8107aca9>] ftrace_replace_code+0x1d6/0x331
[   11.140000]  [<ffffffff81164ebc>] ? trace_graph_function+0x78/0x78
[   11.140000]  [<ffffffff811525f1>] ftrace_modify_all_code+0x41/0xca
[   11.140000]  [<ffffffff8107ae19>] arch_ftrace_update_code+0x15/0x1e
[   11.140000]  [<ffffffff81152b2c>] ftrace_run_update_code+0x2b/0x1b2
[   11.140000]  [<ffffffff81164ebc>] ? trace_graph_function+0x78/0x78
[   11.140000]  [<ffffffff81152ce5>] ftrace_startup_enable+0x32/0x34
[   11.140000]  [<ffffffff81152e25>] ftrace_startup+0x13e/0x148
[   11.140000]  [<ffffffff8115443b>] register_ftrace_graph+0x235/0x252
[   11.140000]  [<ffffffff8115f982>] ? ftrace_dump+0x241/0x241
[   11.140000]  [<ffffffff8441060b>] trace_selftest_startup_function_graph+0x57/0xe3
[   11.140000]  [<ffffffff8115eeac>] register_tracer+0x165/0x288
[   11.140000]  [<ffffffff84410c87>] ? init_graph_debugfs+0x2f/0x2f
[   11.140000]  [<ffffffff84410ced>] init_graph_trace+0x66/0x68
[   11.140000]  [<ffffffff8100216d>] do_one_initcall+0xee/0x17e
[   11.140000]  [<ffffffff810db300>] ? parse_args+0xfc/0x2b8
[   11.140000]  [<ffffffff843e80bf>] kernel_init_freeable+0x1e2/0x26f
[   11.140000]  [<ffffffff82cfcab5>] ? rest_init+0xc9/0xc9
[   11.140000]  [<ffffffff82cfcac3>] kernel_init+0xe/0xdf
[   11.140000]  [<ffffffff82d3203c>] ret_from_fork+0x7c/0xb0
[   11.140000]  [<ffffffff82cfcab5>] ? rest_init+0xc9/0xc9
[   11.140000] ---[ end trace 94c1e7868964d6b1 ]---
[   11.140000] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.0-rc7-01516-g8585242 #920

The "BUG: sleeping function called" in the parent commit "disappeared"
in commit de89e93 because it happens in much later time:

[  322.056221] smpboot: CPU 1 is now offline
[  322.081569] bnx2fc: CPU 1 offline: Remove Rx thread
[  322.088300] CPU 1 offline: Remove Rx thread
mount.nfs: Connection timed out
run-parts: /etc/kernel-tests/99-trinity exited with return code 32
[  362.720433] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:583
[  362.733241] in_atomic(): 1, irqs_disabled(): 0, pid: 6357, name: reboot
[  362.734867] 2 locks held by reboot/6357:
[  362.735995]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff829d5b5d>] rtnl_lock+0x17/0x19
[  362.738773]  #1:  (rcu_read_lock){......}, at: [<ffffffff810dca0e>] rcu_lock_acquire+0x0/0x20
[  362.741686] CPU: 0 PID: 6357 Comm: reboot Not tainted 3.17.0-rc6-01531-gd068b02 #1333
[  362.750958] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  362.752463]  0000000000000000 ffff88001858fa30 ffffffff82d0d3bf 00000000000018d5
[  362.754976]  ffff88001858fa50 ffffffff810e1e35 ffffffff83fc43c0 0000000000000000
[  362.757523]  ffff88001858fad0 ffffffff82d2e0f7 000000000052001f 0000000000000001
[  362.760103] Call Trace:
[  362.782376]  [<ffffffff82d0d3bf>] dump_stack+0x4d/0x66
[  362.793968]  [<ffffffff810e1e35>] __might_sleep+0x125/0x12a
[  362.795422]  [<ffffffff82d2e0f7>] mutex_lock_nested+0x3e/0x3ec
[  362.796958]  [<ffffffff81d60f4e>] cxgbi_device_find_by_netdev+0x63/0x102
[  362.798562]  [<ffffffff81d60f4e>] ? cxgbi_device_find_by_netdev+0x63/0x102
[  362.800309]  [<ffffffff81d68648>] cxgbi_inet6addr_handler+0x3c/0x83
[  362.801817]  [<ffffffff810dc923>] notifier_call_chain+0x6d/0x93
[  362.803274]  [<ffffffff810dcdc7>] __atomic_notifier_call_chain+0x4c/0x79
[  362.804991]  [<ffffffff810dce08>] atomic_notifier_call_chain+0x14/0x16
[  362.806572]  [<ffffffff82b239b6>] inet6addr_notifier_call_chain+0x1b/0x1d
[  362.808348]  [<ffffffff82aefb5c>] addrconf_ifdown+0x28d/0x321
[  362.809759]  [<ffffffff82af0d7e>] addrconf_notify+0x717/0x7d5
[  362.811192]  [<ffffffff810c6ce5>] ? __local_bh_enable_ip+0xaf/0xb4
[  362.812797]  [<ffffffff82d30fe6>] ? _raw_spin_unlock_bh+0x35/0x38
[  362.815980]  [<ffffffff82af80bb>] ? fib6_run_gc+0xc4/0xcb
[  362.817453]  [<ffffffff810dc923>] notifier_call_chain+0x6d/0x93
[  362.818944]  [<ffffffff810dc923>] ? notifier_call_chain+0x6d/0x93
[  362.820545]  [<ffffffff810dc96d>] raw_notifier_call_chain+0x14/0x16
[  362.822095]  [<ffffffff829c52bb>] call_netdevice_notifiers_info+0x52/0x59
[  362.823725]  [<ffffffff829c52d5>] call_netdevice_notifiers+0x13/0x15
[  362.825368]  [<ffffffff829cc19e>] __dev_notify_flags+0x53/0x81
[  362.826838]  [<ffffffff829cc814>] dev_change_flags+0x4e/0x59
[  362.828374]  [<ffffffff82aa877a>] devinet_ioctl+0x267/0x566
[  362.829731]  [<ffffffff82aa91f7>] inet_ioctl+0x86/0xa2
[  362.831085]  [<ffffffff82aa91f7>] ? inet_ioctl+0x86/0xa2
[  362.832482]  [<ffffffff829b25cc>] sock_do_ioctl+0x25/0x42
[  362.833941]  [<ffffffff829b2ad8>] sock_ioctl+0x213/0x21f
[  362.835346]  [<ffffffff811e532f>] vfs_ioctl+0x18/0x34
[  362.836692]  [<ffffffff811e5b9a>] do_vfs_ioctl+0x39a/0x442
[  362.838237]  [<ffffffff811e5c99>] SyS_ioctl+0x57/0x79
[  362.839545]  [<ffffffff82d31d50>] tracesys+0xdd/0xe2
[  364.099570] Unregister pv shared memory for cpu 0
[  364.137326] reboot: Restarting system
[  364.138391] reboot: machine restart

Thanks,
Fengguang

--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc7-01516-g8585242 (kbuild@xian) (gcc v=
ersion 4.9.1 (Debian 4.9.1-11) ) #920 SMP Thu Oct 2 21:19:46 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yoct=
o-x86_64-58/rand_boot-1-yocto-minimal-x86_64.cgz-x86_64-allyesdebian-858524=
2ddf6093480242bf922cb52219e894a20d-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kerne=
l/x86_64-allyesdebian/8585242ddf6093480242bf922cb52219e894a20d/vmlinuz-3.17=
=2E0-rc7-01516-g8585242 kconfig=3Dx86_64-allyesdebian commit=3D8585242ddf60=
93480242bf922cb52219e894a20d branch=3Dlinux-devel/devel-xian-x86_64-2014100=
22109 root=3D/dev/ram0 max_uptime=3D18000 RESULT_ROOT=3D/result/vm-kbuild-y=
octo-x86_64/boot/1/yocto-minimal-x86_64.cgz/x86_64-allyesdebian/8585242ddf6=
093480242bf922cb52219e894a20d/0 ip=3D::::vm-kbuild-yocto-x86_64-58::dhcp ea=
rlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.r=
cu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dp=
anic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,11520=
0 console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000023ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000023ffe000-0x0000000023ffffff] reser=
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
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x23ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdad0-0x000fdadf] mapped at =
[ffff8800000fdad0]
[    0.000000]   mpc: fdae0-fdbe8
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x05764000, 0x05764fff] PGTABLE
[    0.000000] BRK [0x05765000, 0x05765fff] PGTABLE
[    0.000000] BRK [0x05766000, 0x05766fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23800000-0x239fffff]
[    0.000000]  [mem 0x23800000-0x239fffff] page 4k
[    0.000000] BRK [0x05767000, 0x05767fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x20000000-0x237fffff]
[    0.000000]  [mem 0x20000000-0x237fffff] page 4k
[    0.000000] BRK [0x05768000, 0x05768fff] PGTABLE
[    0.000000] BRK [0x05769000, 0x05769fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x1fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x23a00000-0x23ffdfff]
[    0.000000]  [mem 0x23a00000-0x23ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x23ae7000-0x23feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD970 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000023FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000023FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000023FFE4F0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000023FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000023FFF800 000735 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000023FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000023FFF6A0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000023ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x23ffdfff]
[    0.000000]   NODE_DATA [mem 0x23ff9000-0x23ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:23ff1001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00009fffff] PMD -> [ffff88002260000=
0-ffff880022ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x23ffdfff]
[    0.000000] On node 0 totalpages: 147356
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 2240 pages used for memmap
[    0.000000]   DMA32 zone: 143358 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
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
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f4000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x24000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:1 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 478 pages/cpu @ffff880023600000 s1929216 r8=
192 d20480 u2097152
[    0.000000] pcpu-alloc: s1929216 r8192 d20480 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2360e440
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 145031
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbui=
ld-yocto-x86_64-58/rand_boot-1-yocto-minimal-x86_64.cgz-x86_64-allyesdebian=
-8585242ddf6093480242bf922cb52219e894a20d-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=
=3D/kernel/x86_64-allyesdebian/8585242ddf6093480242bf922cb52219e894a20d/vml=
inuz-3.17.0-rc7-01516-g8585242 kconfig=3Dx86_64-allyesdebian commit=3D85852=
42ddf6093480242bf922cb52219e894a20d branch=3Dlinux-devel/devel-xian-x86_64-=
201410022109 root=3D/dev/ram0 max_uptime=3D18000 RESULT_ROOT=3D/result/vm-k=
build-yocto-x86_64/boot/1/yocto-minimal-x86_64.cgz/x86_64-allyesdebian/8585=
242ddf6093480242bf922cb52219e894a20d/0 ip=3D::::vm-kbuild-yocto-x86_64-58::=
dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcu=
pdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watch=
dog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS=
0,115200 console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 496952K/589424K available (29924K kernel code, 4154K=
 rwdata, 14860K rodata, 4452K init, 17328K bss, 92472K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:33024 nr_irqs:256 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc7-01516-g8585242 (kbuild@xian) (gcc v=
ersion 4.9.1 (Debian 4.9.1-11) ) #920 SMP Thu Oct 2 21:19:46 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yoct=
o-x86_64-58/rand_boot-1-yocto-minimal-x86_64.cgz-x86_64-allyesdebian-858524=
2ddf6093480242bf922cb52219e894a20d-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kerne=
l/x86_64-allyesdebian/8585242ddf6093480242bf922cb52219e894a20d/vmlinuz-3.17=
=2E0-rc7-01516-g8585242 kconfig=3Dx86_64-allyesdebian commit=3D8585242ddf60=
93480242bf922cb52219e894a20d branch=3Dlinux-devel/devel-xian-x86_64-2014100=
22109 root=3D/dev/ram0 max_uptime=3D18000 RESULT_ROOT=3D/result/vm-kbuild-y=
octo-x86_64/boot/1/yocto-minimal-x86_64.cgz/x86_64-allyesdebian/8585242ddf6=
093480242bf922cb52219e894a20d/0 ip=3D::::vm-kbuild-yocto-x86_64-58::dhcp ea=
rlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.r=
cu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dp=
anic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,11520=
0 console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000023ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000023ffe000-0x0000000023ffffff] reser=
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
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x23ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdad0-0x000fdadf] mapped at =
[ffff8800000fdad0]
[    0.000000]   mpc: fdae0-fdbe8
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x05764000, 0x05764fff] PGTABLE
[    0.000000] BRK [0x05765000, 0x05765fff] PGTABLE
[    0.000000] BRK [0x05766000, 0x05766fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23800000-0x239fffff]
[    0.000000]  [mem 0x23800000-0x239fffff] page 4k
[    0.000000] BRK [0x05767000, 0x05767fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x20000000-0x237fffff]
[    0.000000]  [mem 0x20000000-0x237fffff] page 4k
[    0.000000] BRK [0x05768000, 0x05768fff] PGTABLE
[    0.000000] BRK [0x05769000, 0x05769fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x1fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x23a00000-0x23ffdfff]
[    0.000000]  [mem 0x23a00000-0x23ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x23ae7000-0x23feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD970 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000023FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000023FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000023FFE4F0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000023FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000023FFF800 000735 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000023FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000023FFF6A0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000023ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x23ffdfff]
[    0.000000]   NODE_DATA [mem 0x23ff9000-0x23ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:23ff1001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00009fffff] PMD -> [ffff88002260000=
0-ffff880022ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x23ffdfff]
[    0.000000] On node 0 totalpages: 147356
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 2240 pages used for memmap
[    0.000000]   DMA32 zone: 143358 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
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
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f4000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x24000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:1 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 478 pages/cpu @ffff880023600000 s1929216 r8=
192 d20480 u2097152
[    0.000000] pcpu-alloc: s1929216 r8192 d20480 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2360e440
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 145031
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbui=
ld-yocto-x86_64-58/rand_boot-1-yocto-minimal-x86_64.cgz-x86_64-allyesdebian=
-8585242ddf6093480242bf922cb52219e894a20d-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=
=3D/kernel/x86_64-allyesdebian/8585242ddf6093480242bf922cb52219e894a20d/vml=
inuz-3.17.0-rc7-01516-g8585242 kconfig=3Dx86_64-allyesdebian commit=3D85852=
42ddf6093480242bf922cb52219e894a20d branch=3Dlinux-devel/devel-xian-x86_64-=
201410022109 root=3D/dev/ram0 max_uptime=3D18000 RESULT_ROOT=3D/result/vm-k=
build-yocto-x86_64/boot/1/yocto-minimal-x86_64.cgz/x86_64-allyesdebian/8585=
242ddf6093480242bf922cb52219e894a20d/0 ip=3D::::vm-kbuild-yocto-x86_64-58::=
dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcu=
pdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watch=
dog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS=
0,115200 console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 496952K/589424K available (29924K kernel code, 4154K=
 rwdata, 14860K rodata, 4452K init, 17328K bss, 92472K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:33024 nr_irqs:256 0
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
[    0.000000] tsc: Detected 2693.452 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5386.90 Bogo=
MIPS (lpj=3D10773808)
[    0.012010] pid_max: default: 32768 minimum: 301
[    0.013308] ACPI: Core revision 20140724
[    0.061678] ACPI: All ACPI Tables successfully acquired
[    0.064983] Security Framework initialized
[    0.068016] AppArmor: AppArmor disabled by boot time parameter
[    0.072981] Dentry cache hash table entries: 131072 (order: 8, 1048576 b=
ytes)
[    0.075419] Inode-cache hash table entries: 65536 (order: 7, 524288 byte=
s)
[    0.076607] Mount-cache hash table entries: 2048 (order: 2, 16384 bytes)
[    0.080079] Mountpoint-cache hash table entries: 2048 (order: 2, 16384 b=
ytes)
[    0.093164] Initializing cgroup subsys devices
[    0.094358] Initializing cgroup subsys freezer
[    0.096095] Initializing cgroup subsys net_cls
[    0.100087] Initializing cgroup subsys blkio
[    0.104371] mce: CPU supports 10 MCE banks
[    0.105474] numa_add_cpu cpu 0 node 0: mask now 0
[    0.108017] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.108017] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.204683] debug: unmapping init [mem 0xffffffff84669000-0xffffffff8467=
5fff]
[    0.213322] ftrace: allocating 118818 entries in 465 pages
[    0.304763] Getting VERSION: 1050014
[    0.308018] Getting VERSION: 1050014
[    0.308962] Getting ID: 0
[    0.309778] Getting ID: ff000000
[    0.312024] Getting LVT0: 8700
[    0.312869] Getting LVT1: 8400
[    0.313990] Enabling x2apic
[    0.314873] Enabled x2apic
[    0.316018] Switched APIC routing to physical x2apic.
[    0.320123] enabled ExtINT on CPU#0
[    0.325009] ENABLING IO-APIC IRQs
[    0.326094] init IO_APIC IRQs
[    0.328017]  apic 0 pin 0 not connected
[    0.329043] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:0)
[    0.332075] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:0)
[    0.336034] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:0)
[    0.338092] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:0)
[    0.340056] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:0)
[    0.341950] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:0)
[    0.344058] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:0)
[    0.348044] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:0)
[    0.352059] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:0)
[    0.353935] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:0)
[    0.356057] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:0)
[    0.364052] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:0)
[    0.366032] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:0)
[    0.367937] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:0)
[    0.368054] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:0)
[    0.372054] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:0)
[    0.376042]  apic 0 pin 16 not connected
[    0.377019]  apic 0 pin 17 not connected
[    0.377990]  apic 0 pin 18 not connected
[    0.380009]  apic 0 pin 19 not connected
[    0.381086]  apic 0 pin 20 not connected
[    0.384012]  apic 0 pin 21 not connected
[    0.388010]  apic 0 pin 22 not connected
[    0.388974]  apic 0 pin 23 not connected
[    0.392170] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.396012] smpboot: CPU0: Intel Xeon E312xx (Sandy Bridge) (fam: 06, mo=
del: 2a, stepping: 01)
[    0.400615] TSC deadline timer enabled
[    0.401657] Performance Events: unsupported p6 CPU model 42 no PMU drive=
r, software events only.
[    0.409914] Testing tracer nop: PASSED
[    0.413511] x86: Booted up 1 node, 1 CPUs
[    0.416034] ----------------
[    0.416848] | NMI testsuite:
[    0.417654] --------------------
[    0.418468]   remote IPI:  ok  |
[    0.420572]    local IPI:
[    0.421163] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.424043]   ok  |
[    0.424936] --------------------
[    0.428014] Good, all   2 testcases passed! |
[    0.429060] ---------------------------------
[    0.430083] smpboot: Total of 1 processors activated (5386.90 BogoMIPS)
[    0.437222] devtmpfs: initialized
[    0.467570] Testing tracer function: PASSED
[    1.110257] Testing dynamic ftrace: PASSED
[    2.040547] Testing dynamic ftrace ops #1: (1 0 1 0 0) (1 1 2 0 0) (2 1 =
3 0 116487) (2 2 4 0 116734) PASSED
[    3.694007] Testing dynamic ftrace ops #2: (1 0 1 116454 0) (1 1 2 11684=
0 0) (2 1 3 1 383) (2 2 4 223 605) PASSED
[    5.096011] Testing ftrace recursion: PASSED
[    5.210518] Testing ftrace recursion safe: PASSED
[    5.329059] Testing ftrace regs: PASSED
[    5.520886] Testing tracer irqsoff: PASSED
[    7.063974] Testing tracer wakeup: ret =3D 0
[    8.216222] ftrace-test (15) used greatest stack depth: 14536 bytes left
[    8.217681] PASSED
[    8.218432] Testing tracer wakeup_rt:=20
[    8.905011] [sched_delayed] sched: RT throttling activated
[    8.905107] ret =3D 0
[    9.516149] PASSED
[    9.516797] Testing tracer wakeup_dl: ret =3D 0
[   10.644181] PASSED
[   10.644938] Testing tracer function_graph:=20
[   11.136016] ------------[ cut here ]------------
[   11.140000] WARNING: CPU: 0 PID: 1 at kernel/trace/trace_functions_graph=
=2Ec:224 ftrace_return_to_handler+0xd2/0x1a8()
[   11.140000] Bad frame pointer: expected ffff880023603eb8, received ffff8=
80023603ef0
[   11.140000]   from func __calc_delta return to ffffffff810e981c
[   11.140000] Modules linked in:
[   11.140000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc7-01516-g=
8585242 #920
[   11.140000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   11.140000]  0000000000000000 ffff880023603db8 ffffffff82d0d960 ffff8800=
23603e00
[   11.140000]  ffff880023603df0 ffffffff810c3476 ffffffff81164abb ffffffff=
82d05448
[   11.140000]  ffff8800237d6238 ffff8800237d6180 0000000000000000 ffff8800=
23603e58
[   11.140000] Call Trace:
[   11.140000]  <IRQ>  [<ffffffff82d0d960>] dump_stack+0x4d/0x66
[   11.140000]  [<ffffffff810c3476>] warn_slowpath_common+0x7f/0x98
[   11.140000]  [<ffffffff81164abb>] ? ftrace_return_to_handler+0xd2/0x1a8
[   11.140000]  [<ffffffff82d05448>] ? set_tsk_thread_flag+0x13/0x13
[   11.140000]  [<ffffffff810c34d7>] warn_slowpath_fmt+0x48/0x50
[   11.140000]  [<ffffffff810e9461>] ? __calc_delta+0x15/0xae
[   11.140000]  [<ffffffff81164abb>] ftrace_return_to_handler+0xd2/0x1a8
[   11.140000]  [<ffffffff810e981c>] ? sched_slice+0x74/0x87
[   11.140000]  [<ffffffff82d3485e>] ? ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff810e981c>] sched_slice+0x74/0x87
[   11.140000]  [<ffffffff810e981c>] ? sched_slice+0x74/0x87
[   11.140000]  [<ffffffff82d34873>] return_to_handler+0x15/0x32
[   11.140000]  [<ffffffff82d3485e>] ? ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff810ebe79>] task_tick_fair+0x88/0x109
[   11.140000]  [<ffffffff8107a7e3>] ? ftrace_write+0x23/0x4c
[   11.140000]  [<ffffffff82d3485e>] ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff810e54be>] scheduler_tick+0x57/0x89
[   11.140000]  [<ffffffff82d3485e>] ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff811195c8>] update_process_times+0x56/0x65
[   11.140000]  [<ffffffff82d3485e>] ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff811240dd>] tick_periodic+0xa1/0xad
[   11.140000]  [<ffffffff82d3485e>] ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff8112427d>] tick_handle_periodic+0x26/0x60
[   11.140000]  [<ffffffff81089300>] ? __virt_addr_valid+0x66/0x8d
[   11.140000]  [<ffffffff82d3485e>] ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff8107556a>] local_apic_timer_interrupt+0x54/0x57
[   11.140000]  [<ffffffff82d3485e>] ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff82d3501d>] smp_apic_timer_interrupt+0x2b/0x3c
[   11.140000]  [<ffffffff82d33082>] apic_timer_interrupt+0x72/0x80
[   11.140000]  <EOI>  [<ffffffff81080ac3>] ? pvclock_clocksource_read+0x76=
/0xa0
[   11.140000]  [<ffffffff81164d97>] ? trace_graph_entry+0x175/0x18b
[   11.140000]  [<ffffffff8108937b>] ? __phys_addr_symbol+0x4/0x24
[   11.140000]  [<ffffffff8107ff56>] kvm_clock_read+0x27/0x31
[   11.140000]  [<ffffffff81051ebc>] paravirt_sched_clock+0x9/0xd
[   11.140000]  [<ffffffff81052506>] sched_clock+0x9/0xb
[   11.140000]  [<ffffffff8114fda6>] trace_clock_local+0x11/0x1b
[   11.140000]  [<ffffffff81164916>] ftrace_push_return_trace+0x76/0x149
[   11.140000]  [<ffffffff8107a7e3>] ? ftrace_write+0x23/0x4c
[   11.140000]  [<ffffffff8108937b>] ? __phys_addr_symbol+0x4/0x24
[   11.140000]  [<ffffffff8107af30>] prepare_ftrace_return+0xa2/0xb5
[   11.140000]  [<ffffffff8108937b>] ? __phys_addr_symbol+0x4/0x24
[   11.140000]  [<ffffffff82d34833>] ftrace_graph_caller+0x53/0x7e
[   11.140000]  [<ffffffff810f9873>] ? trace_hardirqs_on_caller+0x18f/0x1ab
[   11.140000]  [<ffffffff81164f4a>] ? trace_graph_return+0x8e/0x97
[   11.140000]  [<ffffffff8107a7e3>] ? ftrace_write+0x23/0x4c
[   11.140000]  [<ffffffff811420f6>] ? audit_find_rule+0x12/0x108
[   11.140000]  [<ffffffff811420f1>] ? audit_find_rule+0xd/0x108
[   11.140000]  [<ffffffff81089380>] ? __phys_addr_symbol+0x9/0x24
[   11.140000]  [<ffffffff81089380>] ? __phys_addr_symbol+0x9/0x24
[   11.140000]  [<ffffffff82d3485e>] ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff8107aca9>] ftrace_replace_code+0x1d6/0x331
[   11.140000]  [<ffffffff81164ebc>] ? trace_graph_function+0x78/0x78
[   11.140000]  [<ffffffff811525f1>] ftrace_modify_all_code+0x41/0xca
[   11.140000]  [<ffffffff8107ae19>] arch_ftrace_update_code+0x15/0x1e
[   11.140000]  [<ffffffff81152b2c>] ftrace_run_update_code+0x2b/0x1b2
[   11.140000]  [<ffffffff81164ebc>] ? trace_graph_function+0x78/0x78
[   11.140000]  [<ffffffff81152ce5>] ftrace_startup_enable+0x32/0x34
[   11.140000]  [<ffffffff81152e25>] ftrace_startup+0x13e/0x148
[   11.140000]  [<ffffffff8115443b>] register_ftrace_graph+0x235/0x252
[   11.140000]  [<ffffffff8115f982>] ? ftrace_dump+0x241/0x241
[   11.140000]  [<ffffffff8441060b>] trace_selftest_startup_function_graph+=
0x57/0xe3
[   11.140000]  [<ffffffff8115eeac>] register_tracer+0x165/0x288
[   11.140000]  [<ffffffff84410c87>] ? init_graph_debugfs+0x2f/0x2f
[   11.140000]  [<ffffffff84410ced>] init_graph_trace+0x66/0x68
[   11.140000]  [<ffffffff8100216d>] do_one_initcall+0xee/0x17e
[   11.140000]  [<ffffffff810db300>] ? parse_args+0xfc/0x2b8
[   11.140000]  [<ffffffff843e80bf>] kernel_init_freeable+0x1e2/0x26f
[   11.140000]  [<ffffffff82cfcab5>] ? rest_init+0xc9/0xc9
[   11.140000]  [<ffffffff82cfcac3>] kernel_init+0xe/0xdf
[   11.140000]  [<ffffffff82d3203c>] ret_from_fork+0x7c/0xb0
[   11.140000]  [<ffffffff82cfcab5>] ? rest_init+0xc9/0xc9
[   11.140000] ---[ end trace 94c1e7868964d6b1 ]---
[   11.140000] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.17.=
0-rc7-01516-g8585242 #920
[   11.140000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   11.140000]  0000000000000000 ffff880023603e40 ffffffff82d0d960 ffffffff=
82d05448
[   11.140000]  ffff880023603ec0 ffffffff82d05516 ffff880000000008 ffff8800=
23603ed0
[   11.140000]  ffff880023603e68 ffffffff81164b64 ffffffff81164f3b ffff8800=
21d20078
[   11.140000] Call Trace:
[   11.140000]  <IRQ>  [<ffffffff82d0d960>] dump_stack+0x4d/0x66
[   11.140000]  [<ffffffff82d05448>] ? set_tsk_thread_flag+0x13/0x13
[   11.140000]  [<ffffffff82d05516>] panic+0xce/0x206
[   11.140000]  [<ffffffff81164b64>] ? ftrace_return_to_handler+0x17b/0x1a8
[   11.140000]  [<ffffffff81164f3b>] ? trace_graph_return+0x7f/0x97
[   11.140000]  [<ffffffff8107a7e3>] ? ftrace_write+0x23/0x4c
[   11.140000]  [<ffffffff82d3485e>] ? ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff810ebe79>] task_tick_fair+0x88/0x109
[   11.140000]  [<ffffffff82d3485e>] ? ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff810e54be>] scheduler_tick+0x57/0x89
[   11.140000]  [<ffffffff82d3485e>] ? ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff811195c8>] update_process_times+0x56/0x65
[   11.140000]  [<ffffffff82d3485e>] ? ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff811240dd>] tick_periodic+0xa1/0xad
[   11.140000]  [<ffffffff81089300>] ? __virt_addr_valid+0x66/0x8d
[   11.140000]  [<ffffffff82d3485e>] ? ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff8112427d>] tick_handle_periodic+0x26/0x60
[   11.140000]  [<ffffffff82d3485e>] ? ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff8107556a>] local_apic_timer_interrupt+0x54/0x57
[   11.140000]  [<ffffffff82d33082>] ? apic_timer_interrupt+0x72/0x80
[   11.140000]  <EOI>  [<ffffffff81080ac3>] ? pvclock_clocksource_read+0x76=
/0xa0
[   11.140000]  [<ffffffff81164d97>] ? trace_graph_entry+0x175/0x18b
[   11.140000]  [<ffffffff8108937b>] ? __phys_addr_symbol+0x4/0x24
[   11.140000]  [<ffffffff8107ff56>] ? kvm_clock_read+0x27/0x31
[   11.140000]  [<ffffffff81051ebc>] ? paravirt_sched_clock+0x9/0xd
[   11.140000]  [<ffffffff81052506>] ? sched_clock+0x9/0xb
[   11.140000]  [<ffffffff8114fda6>] ? trace_clock_local+0x11/0x1b
[   11.140000]  [<ffffffff81164916>] ? ftrace_push_return_trace+0x76/0x149
[   11.140000]  [<ffffffff8107a7e3>] ? ftrace_write+0x23/0x4c
[   11.140000]  [<ffffffff8108937b>] ? __phys_addr_symbol+0x4/0x24
[   11.140000]  [<ffffffff8107af30>] ? prepare_ftrace_return+0xa2/0xb5
[   11.140000]  [<ffffffff8108937b>] ? __phys_addr_symbol+0x4/0x24
[   11.140000]  [<ffffffff82d34833>] ? ftrace_graph_caller+0x53/0x7e
[   11.140000]  [<ffffffff810f9873>] ? trace_hardirqs_on_caller+0x18f/0x1ab
[   11.140000]  [<ffffffff81164f4a>] ? trace_graph_return+0x8e/0x97
[   11.140000]  [<ffffffff8107a7e3>] ? ftrace_write+0x23/0x4c
[   11.140000]  [<ffffffff811420f6>] ? audit_find_rule+0x12/0x108
[   11.140000]  [<ffffffff811420f1>] ? audit_find_rule+0xd/0x108
[   11.140000]  [<ffffffff81089380>] ? __phys_addr_symbol+0x9/0x24
[   11.140000]  [<ffffffff81089380>] ? __phys_addr_symbol+0x9/0x24
[   11.140000]  [<ffffffff82d3485e>] ? ftrace_graph_caller+0x7e/0x7e
[   11.140000]  [<ffffffff82d3501d>] smp_apic_timer_interrupt+0x2b/0x3c
[   11.140000]  [<ffffffff8107aca9>] ? ftrace_replace_code+0x1d6/0x331
[   11.140000]  [<ffffffff81164ebc>] ? trace_graph_function+0x78/0x78
[   11.140000]  [<ffffffff811525f1>] ? ftrace_modify_all_code+0x41/0xca
[   11.140000]  [<ffffffff8107ae19>] ? arch_ftrace_update_code+0x15/0x1e
[   11.140000]  [<ffffffff81152b2c>] ? ftrace_run_update_code+0x2b/0x1b2
[   11.140000]  [<ffffffff81164ebc>] ? trace_graph_function+0x78/0x78
[   11.140000]  [<ffffffff81152ce5>] ? ftrace_startup_enable+0x32/0x34
[   11.140000]  [<ffffffff81152e25>] ? ftrace_startup+0x13e/0x148
[   11.140000]  [<ffffffff8115443b>] ? register_ftrace_graph+0x235/0x252
[   11.140000]  [<ffffffff8115f982>] ? ftrace_dump+0x241/0x241
[   11.140000]  [<ffffffff8441060b>] ? trace_selftest_startup_function_grap=
h+0x57/0xe3
[   11.140000]  [<ffffffff8115eeac>] ? register_tracer+0x165/0x288
[   11.140000]  [<ffffffff84410c87>] ? init_graph_debugfs+0x2f/0x2f
[   11.140000]  [<ffffffff84410ced>] ? init_graph_trace+0x66/0x68
[   11.140000]  [<ffffffff8100216d>] ? do_one_initcall+0xee/0x17e
[   11.140000]  [<ffffffff810db300>] ? parse_args+0xfc/0x2b8
[   11.140000]  [<ffffffff843e80bf>] ? kernel_init_freeable+0x1e2/0x26f
[   11.140000]  [<ffffffff82cfcab5>] ? rest_init+0xc9/0xc9
[   11.140000]  [<ffffffff82cfcac3>] ? kernel_init+0xe/0xdf
[   11.140000]  [<ffffffff82d3203c>] ? ret_from_fork+0x7c/0xb0
[   11.140000]  [<ffffffff82cfcab5>] ? rest_init+0xc9/0xc9

Elapsed time: 35
qemu-system-x86_64 -enable-kvm -cpu SandyBridge -kernel /kernel/x86_64-ally=
esdebian/8585242ddf6093480242bf922cb52219e894a20d/vmlinuz-3.17.0-rc7-01516-=
g8585242 -append 'user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yocto-x86_64-58=
/rand_boot-1-yocto-minimal-x86_64.cgz-x86_64-allyesdebian-8585242ddf6093480=
242bf922cb52219e894a20d-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-al=
lyesdebian/8585242ddf6093480242bf922cb52219e894a20d/vmlinuz-3.17.0-rc7-0151=
6-g8585242 kconfig=3Dx86_64-allyesdebian commit=3D8585242ddf6093480242bf922=
cb52219e894a20d branch=3Dlinux-devel/devel-xian-x86_64-201410022109 root=3D=
/dev/ram0 max_uptime=3D18000 RESULT_ROOT=3D/result/vm-kbuild-yocto-x86_64/b=
oot/1/yocto-minimal-x86_64.cgz/x86_64-allyesdebian/8585242ddf6093480242bf92=
2cb52219e894a20d/0 ip=3D::::vm-kbuild-yocto-x86_64-58::dhcp earlyprintk=3Dt=
tyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dp=
anic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dt=
ty0 vga=3Dnormal rw drbd.minor_count=3D8'  -initrd /fs/sdd1/initrd-vm-kbuil=
d-yocto-x86_64-58 -m 576 -smp 1 -net nic,vlan=3D1,model=3De1000 -net user,v=
lan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltim=
e -drive file=3D/fs/sdd1/disk0-vm-kbuild-yocto-x86_64-58,media=3Ddisk,if=3D=
virtio -drive file=3D/fs/sdd1/disk1-vm-kbuild-yocto-x86_64-58,media=3Ddisk,=
if=3Dvirtio -drive file=3D/fs/sdd1/disk2-vm-kbuild-yocto-x86_64-58,media=3D=
disk,if=3Dvirtio -drive file=3D/fs/sdd1/disk3-vm-kbuild-yocto-x86_64-58,med=
ia=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdd1/disk4-vm-kbuild-yocto-x86_64-5=
8,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdd1/disk5-vm-kbuild-yocto-x86=
_64-58,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-vm-kbuild-yocto=
-x86_64-58 -serial file:/dev/shm/kboot/serial-vm-kbuild-yocto-x86_64-58 -da=
emonize -display none -monitor null=20

--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--oLBj+sq0vYjzfsbl--
