Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaHSLrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:47:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:39255 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbaHSLrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:47:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,893,1400050800"; 
   d="log'?scan'208";a="578699814"
Date: Tue, 19 Aug 2014 19:47:38 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKP <lkp@01.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [vfs mnt_set_mountpoint] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
Message-ID: <20140819114738.GB18960@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <20140819114003.GA18960@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

// Fix email address for Eric and add another oops message.
// This commit seem to generate all kinds of oops.

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit 89f7ca1af15bdfe7a6aed343032a84af2a69f736
Author:     Eric W. Biederman <ebiederman@twitter.com>
AuthorDate: Sun Sep 22 19:37:01 2013 -0700
Commit:     Al Viro <viro@zeniv.linux.org.uk>
CommitDate: Sun Aug 17 07:02:00 2014 -0400

    vfs: Keep a list of mounts on a mount point
    
    To spot any possible problems call BUG if a mountpoint
    is put when it's list of mounts is not empty.
    
    AV: use hlist instead of list_head
    
    Reviewed-by: Miklos Szeredi <miklos@szeredi.hu>
    Signed-off-by: Eric W. Biederman <ebiederman@twitter.com>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

+-----------------------------------------------------------------------------+------------+------------+---------------+
|                                                                             | de0ed92a2f | 89f7ca1af1 | next-20140818 |
+-----------------------------------------------------------------------------+------------+------------+---------------+
| boot_successes                                                              | 204        | 0          | 0             |
| boot_failures                                                               | 1696       | 900        | 11            |
| WARNING:CPU:PID:at_mm/early_ioremap.c:__early_ioremap()                     | 1696       | 643        |               |
| backtrace:acpi_initialize_tables                                            | 1696       | 643        |               |
| backtrace:acpi_table_init                                                   | 1696       | 643        |               |
| backtrace:acpi_boot_table_init                                              | 1696       | 643        |               |
| BUG:kernel_boot_hang                                                        | 542        | 150        | 1             |
| BUG:unable_to_handle_kernel_paging_request                                  | 0          | 356        | 3             |
| Oops                                                                        | 0          | 616        | 6             |
| RIP:mnt_set_mountpoint                                                      | 0          | 543        | 7             |
| BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/rwsem.c | 0          | 627        | 7             |
| INFO:lockdep_is_turned_off                                                  | 0          | 629        | 7             |
| backtrace:do_mount                                                          | 0          | 543        | 7             |
| backtrace:SyS_mount                                                         | 0          | 543        | 7             |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference                        | 0          | 260        | 3             |
| RIP:find_vma_links                                                          | 0          | 52         | 1             |
| backtrace:vm_mmap_pgoff                                                     | 0          | 55         | 2             |
| backtrace:SyS_mmap_pgoff                                                    | 0          | 55         | 2             |
| backtrace:SyS_mmap                                                          | 0          | 55         | 2             |
| invalid_opcode                                                              | 0          | 27         | 1             |
| RIP:filesystems_proc_show                                                   | 0          | 27         | 2             |
| backtrace:vfs_read                                                          | 0          | 33         | 2             |
| backtrace:SyS_read                                                          | 0          | 33         | 2             |
| RIP:anon_vma_interval_tree_insert                                           | 0          | 30         |               |
| backtrace:do_fork                                                           | 0          | 31         |               |
| backtrace:SyS_clone                                                         | 0          | 31         |               |
| general_protection_fault                                                    | 0          | 122        | 3             |
| Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=                   | 0          | 16         |               |
| RIP:kmem_rcu_free                                                           | 0          | 26         |               |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt                       | 0          | 28         |               |
| backtrace:smpboot_thread_fn                                                 | 0          | 27         |               |
| RIP:find_vma                                                                | 0          | 1          |               |
| WARNING:CPU:PID:at_kernel/locking/lockdep.c:__bfs()                         | 0          | 2          |               |
| RIP:__bfs                                                                   | 0          | 2          |               |
| backtrace:do_group_exit                                                     | 0          | 52         |               |
| backtrace:SyS_exit_group                                                    | 0          | 52         |               |
| RIP:tty_ioctl                                                               | 0          | 1          |               |
| RIP:tty_write                                                               | 0          | 1          |               |
| backtrace:do_vfs_ioctl                                                      | 0          | 1          |               |
| backtrace:SyS_ioctl                                                         | 0          | 1          |               |
| backtrace:vfs_write                                                         | 0          | 1          |               |
| backtrace:SyS_write                                                         | 0          | 1          |               |
| WARNING:CPU:PID:at_mm/page_alloc.c:__alloc_pages_nodemask()                 | 0          | 2          |               |
| BUG:Bad_page_state_in_process                                               | 0          | 7          |               |
| RIP:free_pages_prepare                                                      | 0          | 7          |               |
| backtrace:vm_munmap                                                         | 0          | 2          |               |
| backtrace:SyS_munmap                                                        | 0          | 2          |               |
| RIP:single_next                                                             | 0          | 1          |               |
| INFO:task_blocked_for_more_than_seconds                                     | 0          | 2          | 1             |
| RIP:flat_send_IPI_mask                                                      | 0          | 2          | 1             |
| Kernel_panic-not_syncing:hung_task:blocked_tasks                            | 0          | 2          | 1             |
| backtrace:watchdog                                                          | 0          | 2          | 1             |
| RIP:__lock_acquire                                                          | 0          | 3          |               |
| RIP:put_cred_rcu                                                            | 0          | 1          |               |
| RIP:seq_vprintf                                                             | 0          | 4          |               |
| INFO:trying_to_register_non-static_key                                      | 0          | 2          |               |
| RIP:down_write                                                              | 0          | 1          |               |
| BUG:scheduling_while_atomic                                                 | 0          | 4          |               |
| BUG:Bad_page_map_in_process                                                 | 0          | 1          |               |
| kernel_BUG_at_include/linux/swapops.h                                       | 0          | 1          |               |
| RIP:unmap_single_vma                                                        | 0          | 1          |               |
| RIP:unmapped_area_topdown                                                   | 0          | 1          |               |
| RIP:slob_page_alloc                                                         | 0          | 1          |               |
| backtrace:prepare_creds                                                     | 0          | 1          |               |
| backtrace:SyS_faccessat                                                     | 0          | 1          |               |
| backtrace:SyS_access                                                        | 0          | 1          |               |
| BUG:sleeping_function_called_from_invalid_context_at_mm/memory.c            | 0          | 1          |               |
| kernel_BUG_at_fs/namespace.c                                                | 0          | 17         |               |
| RIP:put_mountpoint                                                          | 0          | 17         |               |
| backtrace:umount_tree                                                       | 0          | 17         |               |
| backtrace:SyS_umount                                                        | 0          | 17         |               |
| is_trying_to_release_lock(file_systems_lock)at                              | 0          | 1          |               |
| RIP:anon_vma_interval_tree_remove                                           | 0          | 4          |               |
| RIP:unlink_anon_vmas                                                        | 0          | 1          |               |
| backtrace:do_execve                                                         | 0          | 1          |               |
| backtrace:SyS_execve                                                        | 0          | 1          |               |
| backtrace:vfs_stat                                                          | 0          | 1          |               |
| backtrace:SyS_newstat                                                       | 0          | 1          |               |
| backtrace:vfs_mkdir                                                         | 0          | 1          |               |
| backtrace:SyS_mkdirat                                                       | 0          | 1          |               |
| backtrace:SyS_mkdir                                                         | 0          | 1          |               |
+-----------------------------------------------------------------------------+------------+------------+---------------+

mountall: Event failed
[    9.750309] init: Failed to create pty - disabling logging for job
[    9.764652] init: Temporary process spawn error: No such file or directory
[    9.808126] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    9.809013] CPU: 0 PID: 162 Comm: mount Not tainted 3.16.0-10291-g89f7ca1 #1
[    9.809013] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    9.809013] task: ffff88000bb36000 ti: ffff88000bb50000 task.ti: ffff88000bb50000
[    9.809013] RIP: 0010:[<ffffffff811a81d6>]  [<ffffffff811a81d6>] filesystems_proc_show+0xa/0x8d
[    9.809013] RSP: 0018:ffff88000bb53e88  EFLAGS: 00010203
[    9.809013] RAX: ffff88000bb3f7dd RBX: 0000000000000000 RCX: 800000000bb8c060
[    9.809013] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88000bb3f728
[    9.809013] RBP: ffff88000bb53ef0 R08: 0000000000000001 R09: 000000000000bb8c
[    9.809013] R10: 0000000000000000 R11: 0000000000000222 R12: 0000000000000400
[    9.809013] R13: ffff88000bb53f58 R14: ffff88000bb3f728 R15: ffff88000bb9c800
[    9.809013] FS:  00007fd52c855800(0000) GS:ffffffff81b7c000(0000) knlGS:0000000000000000
[    9.809013] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    9.809013] CR2: 0000000000618008 CR3: 000000000bbfe000 CR4: 00000000000406b0
[    9.809013] Stack:
[    9.809013]  ffff88000bb53ef0 ffffffff811aef31 ffff88000bb36488 0000000000000001
[    9.809013]  ffff88000bb3f768 00007fd52c85b000 0000000000000000 ffff88000bb53ee8
[    9.809013]  ffff88000c36aa50 00007fd52c85b000 ffff88000bb53f58 0000000000000000
[    9.809013] Call Trace:
[    9.809013]  [<ffffffff811aef31>] ? seq_read+0x1dc/0x4a4
[    9.809013]  [<ffffffff811cfd6f>] proc_reg_read+0x5a/0x9b
[    9.809013]  [<ffffffff811cfd15>] ? proc_reg_write+0x9b/0x9b
[    9.809013]  [<ffffffff81182783>] vfs_read+0xad/0x129
[    9.809013]  [<ffffffff81182c07>] SyS_read+0x5e/0xcf
[    9.809013]  [<ffffffff8172e111>] tracesys+0xd3/0xd8
[    9.809013] Code: 31 d2 48 c7 c6 cc 81 1a 81 48 ff 05 05 62 b3 01 48 89 e5 e8 ad 77 00 00 48 ff 05 fe 61 b3 01 5d c3 55 48 ff 05 bc 61 b3 01 b0 dd <60> 0d 00 88 ff ff 48 c7 c7 c0 db c0 81 53 e8 60 4e 58 00 48 8b 
[    9.809013] RIP  [<ffffffff811a81d6>] filesystems_proc_show+0xa/0x8d
[    9.809013]  RSP <ffff88000bb53e88>
[    9.883837] ---[ end trace 4f22e95511a0a94c ]---
mountall: mount /dev/pts [162] killed by SEGV signal

git bisect start f68f82364938548b58b51d4b926642b0a3cf4c27 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9 --
git bisect  bad 473f9639819684765e78d298f192b8030fe1290c  # 17:45      0-     55  Merge remote-tracking branch 'block/for-next'
git bisect good 9a9d24bbcb7185700286b300e1db132a481d0e1f  # 18:06    900+    422  Merge remote-tracking branch 'tile/master'
git bisect  bad c0698b7d9847e0cbc46881368ec9c72474968ad8  # 18:06      0-    298  Merge remote-tracking branch 'hid/for-next'
git bisect good f55058463a57a59e8b5a59f8b4ae1875c7a91a44  # 18:16    900+    435  Merge remote-tracking branch 'fscache/fscache'
git bisect good 76bb1241bec5f597b025b997d6ae7e193dab8289  # 18:32    900+    448  Merge remote-tracking branch 'logfs/master'
git bisect  bad 9016ceb4b3699bc95ffaeed371e5fd0745bab224  # 18:32      0-   1197  Merge remote-tracking branch 'vfs/for-next'
git bisect  bad 76a8a45241be2aff38944e74811e23d1024a71fa  # 18:39     44-     47  vfs: Make d_invalidate return void
git bisect  bad 89f7ca1af15bdfe7a6aed343032a84af2a69f736  # 18:41     70-     72  vfs: Keep a list of mounts on a mount point
git bisect good 7fed866b5ce6f45fb0c226c6ff897d7af3a1176a  # 19:00    900+    680  vfs: Document the effect of d_revalidate on d_find_alias
git bisect good de0ed92a2fbb9eb93a97da7612363c8c3130ec20  # 19:08    900+    784  vfs: Don't allow overwriting mounts in the current mount namespace
# first bad commit: [89f7ca1af15bdfe7a6aed343032a84af2a69f736] vfs: Keep a list of mounts on a mount point
git bisect good de0ed92a2fbb9eb93a97da7612363c8c3130ec20  # 19:12   1000+   1696  vfs: Don't allow overwriting mounts in the current mount namespace
git bisect  bad f68f82364938548b58b51d4b926642b0a3cf4c27  # 19:14      0-     11  Add linux-next specific files for 20140818
git bisect good 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9  # 19:19   1000+   1377  Linux 3.17-rc1
git bisect  bad f68f82364938548b58b51d4b926642b0a3cf4c27  # 19:19      0-     11  Add linux-next specific files for 20140818


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

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
	load_ramdisk=2
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

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-kbuild-5:20140819183934:x86_64-randconfig-ib1-08181713:3.16.0-10291-g89f7ca1:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-10291-g89f7ca1 (kbuild@lkp-hsx01) (gcc =
version 4.8.2 (Debian 4.8.2-18) ) #1 Tue Aug 19 18:39:00 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 pr=
ompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=
=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-ib1-08=
181713/next:master:89f7ca1af15bdfe7a6aed343032a84af2a69f736:bisect-linux-4/=
=2Evmlinuz-89f7ca1af15bdfe7a6aed343032a84af2a69f736-20140819183912-100-kbui=
ld branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib1-08181713=
/89f7ca1af15bdfe7a6aed343032a84af2a69f736/vmlinuz-3.16.0-10291-g89f7ca1 drb=
d.minor_count=3D8
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
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02f2d000, 0x02f2dfff] PGTABLE
[    0.000000] BRK [0x02f2e000, 0x02f2efff] PGTABLE
[    0.000000] BRK [0x02f2f000, 0x02f2ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x02f30000, 0x02f30fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x02f31000, 0x02f31fff] PGTABLE
[    0.000000] BRK [0x02f32000, 0x02f32fff] PGTABLE
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
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
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
[    0.000000] kvm-stealtime: cpu 0, msr 1b9bd40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
 root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-i=
b1-08181713/next:master:89f7ca1af15bdfe7a6aed343032a84af2a69f736:bisect-lin=
ux-4/.vmlinuz-89f7ca1af15bdfe7a6aed343032a84af2a69f736-20140819183912-100-k=
build branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib1-08181=
713/89f7ca1af15bdfe7a6aed343032a84af2a69f736/vmlinuz-3.16.0-10291-g89f7ca1 =
drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 263808K/327280K available (7366K kernel code, 3075K =
rwdata, 4156K rodata, 844K init, 16432K bss, 63472K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-10291-g89f7ca1 (kbuild@lkp-hsx01) (gcc =
version 4.8.2 (Debian 4.8.2-18) ) #1 Tue Aug 19 18:39:00 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 pr=
ompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=
=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-ib1-08=
181713/next:master:89f7ca1af15bdfe7a6aed343032a84af2a69f736:bisect-linux-4/=
=2Evmlinuz-89f7ca1af15bdfe7a6aed343032a84af2a69f736-20140819183912-100-kbui=
ld branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib1-08181713=
/89f7ca1af15bdfe7a6aed343032a84af2a69f736/vmlinuz-3.16.0-10291-g89f7ca1 drb=
d.minor_count=3D8
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
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02f2d000, 0x02f2dfff] PGTABLE
[    0.000000] BRK [0x02f2e000, 0x02f2efff] PGTABLE
[    0.000000] BRK [0x02f2f000, 0x02f2ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x02f30000, 0x02f30fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x02f31000, 0x02f31fff] PGTABLE
[    0.000000] BRK [0x02f32000, 0x02f32fff] PGTABLE
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
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
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
[    0.000000] kvm-stealtime: cpu 0, msr 1b9bd40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
 root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-i=
b1-08181713/next:master:89f7ca1af15bdfe7a6aed343032a84af2a69f736:bisect-lin=
ux-4/.vmlinuz-89f7ca1af15bdfe7a6aed343032a84af2a69f736-20140819183912-100-k=
build branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib1-08181=
713/89f7ca1af15bdfe7a6aed343032a84af2a69f736/vmlinuz-3.16.0-10291-g89f7ca1 =
drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 263808K/327280K available (7366K kernel code, 3075K =
rwdata, 4156K rodata, 844K init, 16432K bss, 63472K reserved)
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
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] allocated 1572864 bytes of page_cgroup
[    0.000000] allocated 1572864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.592 MHz processor
[    0.000000] tsc: Detected 2693.592 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value..=20
[    0.003000] Calibrating delay loop (skipped) preset value.. 5387.18 Bogo=
MIPS (lpj=3D2693592)
5387.18 BogoMIPS (lpj=3D2693592)
[    0.004011] pid_max: default: 32768 minimum: 301
[    0.004011] pid_max: default: 32768 minimum: 301
[    0.005074] ACPI: Core revision 20140724
[    0.005074] ACPI: Core revision 20140724
[    0.020469] ACPI:=20
[    0.020469] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.022251] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.022251] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.023020] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.023020] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.026522] Initializing cgroup subsys memory
[    0.026522] Initializing cgroup subsys memory
[    0.027040] Initializing cgroup subsys devices
[    0.027040] Initializing cgroup subsys devices
[    0.028058] Initializing cgroup subsys freezer
[    0.028058] Initializing cgroup subsys freezer
[    0.029062] Initializing cgroup subsys perf_event
[    0.029062] Initializing cgroup subsys perf_event
[    0.030163] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.030163] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.030163] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.030163] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.031011] CPU:=20
[    0.031011] CPU: Intel Core Processor (Haswell)Intel Core Processor (Has=
well) (fam: 06, model: 3c (fam: 06, model: 3c, stepping: 01)
, stepping: 01)
[    0.042351] Performance Events:=20
[    0.042351] Performance Events: unsupported p6 CPU model 60 unsupported =
p6 CPU model 60 no PMU driver, software events only.
no PMU driver, software events only.
[    0.046715] Getting VERSION: 1050014
[    0.046715] Getting VERSION: 1050014
[    0.047030] Getting VERSION: 1050014
[    0.047030] Getting VERSION: 1050014
[    0.048018] Getting ID: 0
[    0.048018] Getting ID: 0
[    0.049022] Getting ID: ff000000
[    0.049022] Getting ID: ff000000
[    0.050021] Getting LVT0: 8700
[    0.050021] Getting LVT0: 8700
[    0.051016] Getting LVT1: 8400
[    0.051016] Getting LVT1: 8400
[    0.052104] enabled ExtINT on CPU#0
[    0.052104] enabled ExtINT on CPU#0
[    0.055255] ENABLING IO-APIC IRQs
[    0.055255] ENABLING IO-APIC IRQs
[    0.056015] init IO_APIC IRQs
[    0.056015] init IO_APIC IRQs
[    0.057010]  apic 0 pin 0 not connected
[    0.057010]  apic 0 pin 0 not connected
[    0.058085] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.058085] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.059044] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.059044] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.060042] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.060042] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.061045] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.061045] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.062037] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.062037] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.063044] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.063044] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.064036] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.064036] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.065052] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.065052] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.066037] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.066037] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.067042] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.067042] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.068035] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.068035] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.069046] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.069046] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.070039] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.070039] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.071041] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.071041] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.072043] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.072043] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.073030]  apic 0 pin 16 not connected
[    0.073030]  apic 0 pin 16 not connected
[    0.074008]  apic 0 pin 17 not connected
[    0.074008]  apic 0 pin 17 not connected
[    0.075009]  apic 0 pin 18 not connected
[    0.075009]  apic 0 pin 18 not connected
[    0.076007]  apic 0 pin 19 not connected
[    0.076007]  apic 0 pin 19 not connected
[    0.077007]  apic 0 pin 20 not connected
[    0.077007]  apic 0 pin 20 not connected
[    0.078010]  apic 0 pin 21 not connected
[    0.078010]  apic 0 pin 21 not connected
[    0.079007]  apic 0 pin 22 not connected
[    0.079007]  apic 0 pin 22 not connected
[    0.080007]  apic 0 pin 23 not connected
[    0.080007]  apic 0 pin 23 not connected
[    0.081207] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.081207] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.082068] TSC deadline timer enabled
[    0.082068] TSC deadline timer enabled
[    0.083000] devtmpfs: initialized
[    0.083000] devtmpfs: initialized
[    0.090316] gcov: version magic: 0x3430382a
[    0.090316] gcov: version magic: 0x3430382a
[    0.094506] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.094506] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.096102] regulator-dummy: no parameters
[    0.096102] regulator-dummy: no parameters
[    0.097652] NET: Registered protocol family 16
[    0.097652] NET: Registered protocol family 16
[    0.099611] cpuidle: using governor ladder
[    0.099611] cpuidle: using governor ladder
[    0.100021] cpuidle: using governor menu
[    0.100021] cpuidle: using governor menu
[    0.101625] ACPI: bus type PCI registered
[    0.101625] ACPI: bus type PCI registered
[    0.102164] PCI: Using configuration type 1 for base access
[    0.102164] PCI: Using configuration type 1 for base access
[    0.128647] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.128647] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.129052] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.129052] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.130627] ACPI: Added _OSI(Module Device)
[    0.130627] ACPI: Added _OSI(Module Device)
[    0.131016] ACPI: Added _OSI(Processor Device)
[    0.131016] ACPI: Added _OSI(Processor Device)
[    0.132028] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.132028] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.133013] ACPI: Added _OSI(Processor Aggregator Device)
[    0.133013] ACPI: Added _OSI(Processor Aggregator Device)
[    0.149604] ACPI: Interpreter enabled
[    0.149604] ACPI: Interpreter enabled
[    0.150024] ACPI: (supports S0 S5)
[    0.150024] ACPI: (supports S0 S5)
[    0.151008] ACPI: Using IOAPIC for interrupt routing
[    0.151008] ACPI: Using IOAPIC for interrupt routing
[    0.152145] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.152145] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.177768] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.177768] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.178025] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.178025] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.179119] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.179119] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.181526] PCI host bridge to bus 0000:00
[    0.181526] PCI host bridge to bus 0000:00
[    0.182015] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.182015] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.183025] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.183025] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.184013] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.184013] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.185020] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.185020] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.186015] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.186015] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.187143] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.187143] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.189432] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.189432] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.191436] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.191436] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.194947] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.194947] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.196058] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.196058] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.197025] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.197025] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.198012] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.198012] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.199015] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.199015] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.201018] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.201018] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.202673] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.202673] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.203036] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.203036] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.205164] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.205164] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.207755] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.207755] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.209801] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.209801] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.216750] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.216750] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.218806] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.218806] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.220017] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.220017] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.222029] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.222029] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.228627] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.228627] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.230088] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.230088] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.231752] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.231752] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.236786] pci_bus 0000:00: on NUMA node 0
[    0.236786] pci_bus 0000:00: on NUMA node 0
[    0.239426] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.239426] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.241471] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.241471] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.243357] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.243357] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.245873] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.245873] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.247309] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.247309] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.250711] ACPI:=20
[    0.250711] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.254935] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.254935] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.255020] vgaarb: loaded
[    0.255020] vgaarb: loaded
[    0.256009] vgaarb: bridge control possible 0000:00:02.0
[    0.256009] vgaarb: bridge control possible 0000:00:02.0
[    0.258370] Linux video capture interface: v2.00
[    0.258370] Linux video capture interface: v2.00
[    0.259140] pps_core: LinuxPPS API ver. 1 registered
[    0.259140] pps_core: LinuxPPS API ver. 1 registered
[    0.260009] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.260009] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.261681] PCI: Using ACPI for IRQ routing
[    0.261681] PCI: Using ACPI for IRQ routing
[    0.262018] PCI: pci_cache_line_size set to 64 bytes
[    0.262018] PCI: pci_cache_line_size set to 64 bytes
[    0.263233] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.263233] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.264038] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.264038] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.267318] Switched to clocksource kvm-clock
[    0.267318] Switched to clocksource kvm-clock
[    0.269404] FS-Cache: Loaded
[    0.269404] FS-Cache: Loaded
[    0.270694] pnp: PnP ACPI init
[    0.270694] pnp: PnP ACPI init
[    0.272114] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.272114] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.285548] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.285548] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.288931] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.288931] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.293156] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.293156] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.304210] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.304210] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.307504] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.307504] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.310228] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.310228] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.323429] pnp 00:03: [dma 2]
[    0.323429] pnp 00:03: [dma 2]
[    0.325187] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.325187] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.328821] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.328821] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.333691] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.333691] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.346089] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.346089] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.349333] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.349333] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.352089] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.352089] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.363906] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.363906] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.368277] pnp: PnP ACPI: found 7 devices
[    0.368277] pnp: PnP ACPI: found 7 devices
[    0.379434] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.379434] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.395535] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.395535] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.398417] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.398417] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.401532] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.401532] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.414831] NET: Registered protocol family 1
[    0.414831] NET: Registered protocol family 1
[    0.416992] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.416992] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.419890] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.419890] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.422961] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.422961] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.442162] pci 0000:00:02.0: Boot video device
[    0.442162] pci 0000:00:02.0: Boot video device
[    0.444469] PCI: CLS 0 bytes, default 64
[    0.444469] PCI: CLS 0 bytes, default 64
[    0.454143] Unpacking initramfs...
[    0.454143] Unpacking initramfs...
[    3.363827] debug: unmapping init [mem 0xffff88001293d000-0xffff880013fe=
ffff]
[    3.363827] debug: unmapping init [mem 0xffff88001293d000-0xffff880013fe=
ffff]
[    3.383497] microcode: CPU0 sig=3D0x306c1, pf=3D0x1, revision=3D0x1
[    3.383497] microcode: CPU0 sig=3D0x306c1, pf=3D0x1, revision=3D0x1
[    3.386218] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    3.386218] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    3.399386] cryptomgr_test (15) used greatest stack depth: 14616 bytes l=
eft
[    3.399386] cryptomgr_test (15) used greatest stack depth: 14616 bytes l=
eft
[    3.408113] sha1_ssse3: Using AVX optimized SHA-1 implementation
[    3.408113] sha1_ssse3: Using AVX optimized SHA-1 implementation
[    3.417078] sha256_ssse3: Using AVX optimized SHA-256 implementation
[    3.417078] sha256_ssse3: Using AVX optimized SHA-256 implementation
[    3.431519] AVX2 or AES-NI instructions are not detected.
[    3.431519] AVX2 or AES-NI instructions are not detected.
[    3.445661] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    3.445661] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    3.451737] spin_lock-torture: Creating torture_shuffle task
[    3.451737] spin_lock-torture: Creating torture_shuffle task
[    3.458736] spin_lock-torture: Creating torture_stutter task
[    3.458736] spin_lock-torture: Creating torture_stutter task
[    3.462088] spin_lock-torture: torture_shuffle task started
[    3.462088] spin_lock-torture: torture_shuffle task started
[    3.465782] spin_lock-torture: Creating lock_torture_writer task
[    3.465782] spin_lock-torture: Creating lock_torture_writer task
[    3.471086] spin_lock-torture: torture_stutter task started
[    3.471086] spin_lock-torture: torture_stutter task started
[    3.474315] spin_lock-torture: lock_torture_writer task started
[    3.474315] spin_lock-torture: lock_torture_writer task started
[    3.479708] spin_lock-torture: Creating lock_torture_writer task
[    3.479708] spin_lock-torture: Creating lock_torture_writer task
[    3.484255] spin_lock-torture: Creating lock_torture_stats task
[    3.484255] spin_lock-torture: Creating lock_torture_stats task
[    3.494720] spin_lock-torture: lock_torture_writer task started
[    3.494720] spin_lock-torture: lock_torture_writer task started
[    3.497276] spin_lock-torture: lock_torture_stats task started
[    3.497276] spin_lock-torture: lock_torture_stats task started
[    3.502485] futex hash table entries: 256 (order: 2, 20480 bytes)
[    3.502485] futex hash table entries: 256 (order: 2, 20480 bytes)
[    4.368349] tsc: Refined TSC clocksource calibration: 2693.507 MHz
[    4.368349] tsc: Refined TSC clocksource calibration: 2693.507 MHz
[    5.056477] zpool: loaded
[    5.056477] zpool: loaded
[    5.059491] zbud: loaded
[    5.059491] zbud: loaded
[    5.064515] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    5.064515] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    5.066654] fuse init (API version 7.23)
[    5.066654] fuse init (API version 7.23)
[    5.074923] msgmni has been set to 515
[    5.074923] msgmni has been set to 515
[    5.082379] start plist test
[    5.082379] start plist test
[    5.097368] end plist test
[    5.097368] end plist test
[    5.098499] test_string_helpers: Running tests...
[    5.098499] test_string_helpers: Running tests...
[    5.101429] xz_dec_test: module loaded
[    5.101429] xz_dec_test: module loaded
[    5.104237] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
251 0' and write .xz files to it.
[    5.104237] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
251 0' and write .xz files to it.
[    5.119596] rbtree testing
[    5.119596] rbtree testing -> 23947 cycles
 -> 23947 cycles
[    6.098486] augmented rbtree testing
[    6.098486] augmented rbtree testing -> 36471 cycles
 -> 36471 cycles
[    7.592545] no IO addresses supplied
[    7.592545] no IO addresses supplied
[    7.605114] ipmi message handler version 39.2
[    7.605114] ipmi message handler version 39.2
[    7.606923] ipmi device interface
[    7.606923] ipmi device interface
[    7.608582] IPMI System Interface driver.
[    7.608582] IPMI System Interface driver.
[    7.610613] ipmi_si: Unable to find any System Interface(s)
[    7.610613] ipmi_si: Unable to find any System Interface(s)
[    7.612880] IPMI Watchdog: driver initialized
[    7.612880] IPMI Watchdog: driver initialized
[    7.623616] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    7.623616] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    7.627398] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    7.627398] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    7.630416] ACPI: Power Button [PWRF]
[    7.630416] ACPI: Power Button [PWRF]
[    7.796443] r3964: Philips r3964 Driver $Revision: 1.10 $
[    7.796443] r3964: Philips r3964 Driver $Revision: 1.10 $
[    7.805219] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    7.805219] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    7.863783] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    7.863783] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    7.870509] serial: Freescale lpuart driver
[    7.870509] serial: Freescale lpuart driver
[    7.885330] lp: driver loaded but no devices found
[    7.885330] lp: driver loaded but no devices found
[    7.887338] ppdev: user-space parallel port driver
[    7.887338] ppdev: user-space parallel port driver
[    7.889312] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    7.889312] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    7.891781] [drm] Initialized drm 1.1.0 20060810
[    7.891781] [drm] Initialized drm 1.1.0 20060810
[    7.904651] parport_pc 00:04: reported by Plug and Play ACPI
[    7.904651] parport_pc 00:04: reported by Plug and Play ACPI
[    7.907213] parport0: PC-style at 0x378
[    7.907213] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRIS=
TATE,TRISTATE]
]
[    7.994214] lp0: using parport0 (interrupt-driven).
[    7.994214] lp0: using parport0 (interrupt-driven).
[    7.996860] dummy-irq: no IRQ given.  Use irq=3DN
[    7.996860] dummy-irq: no IRQ given.  Use irq=3DN
[    8.002565] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    8.002565] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    8.013189] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    8.013189] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    8.024888] slram: not enough parameters.
[    8.024888] slram: not enough parameters.
[    8.117167] No valid DiskOnChip devices found
[    8.117167] No valid DiskOnChip devices found
[    8.119554] HSI/SSI char device loaded
[    8.119554] HSI/SSI char device loaded
[    8.122912] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    8.122912] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    8.137642] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.137642] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.139782] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.139782] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.142952] parport0: cannot grant exclusive access for device parkbd
[    8.142952] parport0: cannot grant exclusive access for device parkbd
[    8.297380] mousedev: PS/2 mouse device common for all mice
[    8.297380] mousedev: PS/2 mouse device common for all mice
[    8.299956] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    8.299956] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    8.315139] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    8.315139] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    8.320627] ideapad_slidebar: DMI does not match
[    8.320627] ideapad_slidebar: DMI does not match
[    8.322945] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    8.322945] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    8.337804] smssdio: Siano SMS1xxx SDIO driver
[    8.337804] smssdio: Siano SMS1xxx SDIO driver
[    8.339519] smssdio: Copyright Pierre Ossman
[    8.339519] smssdio: Copyright Pierre Ossman
[    8.341318] pps_ldisc: PPS line discipline registered
[    8.341318] pps_ldisc: PPS line discipline registered
[    8.354369] pps_parport: parallel port PPS client
[    8.354369] pps_parport: parallel port PPS client
[    8.356657] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    8.356657] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    8.359331] pps_parport: couldn't register with parport0
[    8.359331] pps_parport: couldn't register with parport0
[    8.361392] Driver for 1-wire Dallas network protocol.
[    8.361392] Driver for 1-wire Dallas network protocol.
[    8.374965] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    8.374965] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    8.378207] power_supply test_ac: uevent
[    8.378207] power_supply test_ac: uevent
[    8.379858] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    8.379858] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    8.393271] power_supply test_ac: prop ONLINE=3D1
[    8.393271] power_supply test_ac: prop ONLINE=3D1
[    8.395131] power_supply test_ac: power_supply_changed
[    8.395131] power_supply test_ac: power_supply_changed
[    8.397182] power_supply test_ac: power_supply_changed_work
[    8.397182] power_supply test_ac: power_supply_changed_work
[    8.399349] power_supply test_ac: uevent
[    8.399349] power_supply test_ac: uevent
[    8.400859] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    8.400859] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    8.413099] power_supply test_ac: prop ONLINE=3D1
[    8.413099] power_supply test_ac: prop ONLINE=3D1
[    8.415645] power_supply test_battery: uevent
[    8.415645] power_supply test_battery: uevent
[    8.417485] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    8.417485] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    8.420216] power_supply test_battery: prop STATUS=3DDischarging
[    8.420216] power_supply test_battery: prop STATUS=3DDischarging
[    8.422643] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    8.422643] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    8.434741] power_supply test_battery: prop HEALTH=3DGood
[    8.434741] power_supply test_battery: prop HEALTH=3DGood
[    8.436772] power_supply test_battery: prop PRESENT=3D1
[    8.436772] power_supply test_battery: prop PRESENT=3D1
[    8.438704] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    8.438704] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    8.440876] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    8.440876] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    8.453299] power_supply test_battery: prop CHARGE_FULL=3D100
[    8.453299] power_supply test_battery: prop CHARGE_FULL=3D100
[    8.455637] power_supply test_battery: prop CHARGE_NOW=3D50
[    8.455637] power_supply test_battery: prop CHARGE_NOW=3D50
[    8.457890] power_supply test_battery: prop CAPACITY=3D50
[    8.457890] power_supply test_battery: prop CAPACITY=3D50
[    8.460082] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    8.460082] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    8.473619] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    8.473619] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    8.476022] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    8.476022] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    8.478362] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    8.478362] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    8.480789] power_supply test_battery: prop MANUFACTURER=3DLinux
[    8.480789] power_supply test_battery: prop MANUFACTURER=3DLinux
[    8.492073] power_supply test_battery: prop SERIAL_NUMBER=3D3.16.0-10291=
-g89f7ca1
[    8.492073] power_supply test_battery: prop SERIAL_NUMBER=3D3.16.0-10291=
-g89f7ca1
[    8.495108] power_supply test_battery: prop TEMP=3D26
[    8.495108] power_supply test_battery: prop TEMP=3D26
[    8.497152] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    8.497152] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    8.499841] power_supply test_battery: power_supply_changed
[    8.499841] power_supply test_battery: power_supply_changed
[    8.513280] power_supply test_battery: power_supply_changed_work
[    8.513280] power_supply test_battery: power_supply_changed_work
[    8.515845] power_supply test_battery: uevent
[    8.515845] power_supply test_battery: uevent
[    8.517673] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    8.517673] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    8.520521] power_supply test_usb: uevent
[    8.520521] power_supply test_usb: uevent
[    8.533247] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    8.533247] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    8.535570] power_supply test_battery: prop STATUS=3DDischarging
[    8.535570] power_supply test_battery: prop STATUS=3DDischarging
[    8.537823] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    8.537823] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    8.539975] power_supply test_battery: prop HEALTH=3DGood
[    8.539975] power_supply test_battery: prop HEALTH=3DGood
[    8.542086] power_supply test_battery: prop PRESENT=3D1
[    8.542086] power_supply test_battery: prop PRESENT=3D1
[    8.554197] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    8.554197] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    8.556590] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    8.556590] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    8.559158] power_supply test_battery: prop CHARGE_FULL=3D100
[    8.559158] power_supply test_battery: prop CHARGE_FULL=3D100
[    8.561486] power_supply test_battery: prop CHARGE_NOW=3D50
[    8.561486] power_supply test_battery: prop CHARGE_NOW=3D50
[    8.573755] power_supply test_battery: prop CAPACITY=3D50
[    8.573755] power_supply test_battery: prop CAPACITY=3D50
[    8.575777] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    8.575777] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    8.578148] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    8.578148] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    8.580526] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    8.580526] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    8.582902] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    8.582902] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    8.595533] power_supply test_battery: prop MANUFACTURER=3DLinux
[    8.595533] power_supply test_battery: prop MANUFACTURER=3DLinux
[    8.597950] power_supply test_battery: prop SERIAL_NUMBER=3D3.16.0-10291=
-g89f7ca1
[    8.597950] power_supply test_battery: prop SERIAL_NUMBER=3D3.16.0-10291=
-g89f7ca1
[    8.600981] power_supply test_battery: prop TEMP=3D26
[    8.600981] power_supply test_battery: prop TEMP=3D26
[    8.613048] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    8.613048] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    8.615361] power_supply test_usb: prop ONLINE=3D1
[    8.615361] power_supply test_usb: prop ONLINE=3D1
[    8.617182] power_supply test_usb: power_supply_changed
[    8.617182] power_supply test_usb: power_supply_changed
[    8.619295] power_supply test_usb: power_supply_changed_work
[    8.619295] power_supply test_usb: power_supply_changed_work
[    8.621525] power_supply test_usb: uevent
[    8.621525] power_supply test_usb: uevent
[    8.632130] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    8.632130] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    8.637706] applesmc: supported laptop not found!
[    8.637706] applesmc: supported laptop not found!
[    8.639674] applesmc: driver init failed (ret=3D-19)!
[    8.639674] applesmc: driver init failed (ret=3D-19)!
[    8.653068] power_supply test_usb: prop ONLINE=3D1
[    8.653068] power_supply test_usb: prop ONLINE=3D1
[    8.659690] sch56xx_common: Unsupported device id: 0xff
[    8.659690] sch56xx_common: Unsupported device id: 0xff
[    8.661883] sch56xx_common: Unsupported device id: 0xff
[    8.661883] sch56xx_common: Unsupported device id: 0xff
[    8.676605] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    8.676605] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    8.679764] acquirewdt: I/O address 0x0043 already in use
[    8.679764] acquirewdt: I/O address 0x0043 already in use
[    8.681908] acquirewdt: probe of acquirewdt failed with error -5
[    8.681908] acquirewdt: probe of acquirewdt failed with error -5
[    8.694625] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    8.694625] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    8.698777] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D0)
[    8.698777] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D0)
[    8.701495] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    8.701495] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    8.712291] ib700wdt: START method I/O 443 is not available
[    8.712291] ib700wdt: START method I/O 443 is not available
[    8.724655] ib700wdt: probe of ib700wdt failed with error -5
[    8.724655] ib700wdt: probe of ib700wdt failed with error -5
[    8.727194] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    8.727194] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    8.730482] wafer5823wdt: I/O address 0x0443 already in use
[    8.730482] wafer5823wdt: I/O address 0x0443 already in use
[    8.732858] it87_wdt: no device
[    8.732858] it87_wdt: no device
[    8.744311] sc1200wdt: build 20020303
[    8.744311] sc1200wdt: build 20020303
[    8.745856] sc1200wdt: io parameter must be specified
[    8.745856] sc1200wdt: io parameter must be specified
[    8.747891] sbc60xxwdt: I/O address 0x0443 already in use
[    8.747891] sbc60xxwdt: I/O address 0x0443 already in use
[    8.749978] cpu5wdt: misc_register failed
[    8.749978] cpu5wdt: misc_register failed
[    8.751527] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    8.751527] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    8.765815] smsc37b787_wdt: Unable to register miscdev on minor 130
[    8.765815] smsc37b787_wdt: Unable to register miscdev on minor 130
[    8.768430] w83977f_wdt: driver v1.00
[    8.768430] w83977f_wdt: driver v1.00
[    8.769995] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    8.769995] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    8.772744] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    8.772744] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    8.785132] machzwd: no ZF-Logic found
[    8.785132] machzwd: no ZF-Logic found
[    8.786649] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    8.786649] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    8.789572] sdhci: Secure Digital Host Controller Interface driver
[    8.789572] sdhci: Secure Digital Host Controller Interface driver
[    8.791930] sdhci: Copyright(c) Pierre Ossman
[    8.791930] sdhci: Copyright(c) Pierre Ossman
[    8.804062] sdhci-pltfm: SDHCI platform and OF driver helper
[    8.804062] sdhci-pltfm: SDHCI platform and OF driver helper
[    8.808771] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    8.808771] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    8.843666]=20
[    8.843666] printing PIC contents
[    8.843666]=20
[    8.843666] printing PIC contents
[    8.845554] ... PIC  IMR: ffff
[    8.845554] ... PIC  IMR: ffff
[    8.846537] ... PIC  IRR: 1013
[    8.846537] ... PIC  IRR: 1013
[    8.847943] ... PIC  ISR: 0000
[    8.847943] ... PIC  ISR: 0000
[    8.849154] ... PIC ELCR: 0c00
[    8.849154] ... PIC ELCR: 0c00
[    8.850357] printing local APIC contents on CPU#0/0:
[    8.850357] printing local APIC contents on CPU#0/0:
[    8.851340] ... APIC ID:      00000000 (0)
[    8.851340] ... APIC ID:      00000000 (0)
[    8.851340] ... APIC VERSION: 01050014
[    8.851340] ... APIC VERSION: 01050014
[    8.851340] ... APIC TASKPRI: 00000000 (00)
[    8.851340] ... APIC TASKPRI: 00000000 (00)
[    8.851340] ... APIC PROCPRI: 00000000
[    8.851340] ... APIC PROCPRI: 00000000
[    8.851340] ... APIC LDR: 01000000
[    8.851340] ... APIC LDR: 01000000
[    8.851340] ... APIC DFR: ffffffff
[    8.851340] ... APIC DFR: ffffffff
[    8.851340] ... APIC SPIV: 000001ff
[    8.851340] ... APIC SPIV: 000001ff
[    8.851340] ... APIC ISR field:
[    8.851340] ... APIC ISR field:
[    8.851340] 00000000
[    8.851340] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    8.851340] ... APIC TMR field:
[    8.851340] ... APIC TMR field:
[    8.851340] 00000000
[    8.851340] 000000000200000002000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    8.851340] ... APIC IRR field:
[    8.851340] ... APIC IRR field:
[    8.851340] 00000000
[    8.851340] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[    8.851340] ... APIC ESR: 00000000
[    8.851340] ... APIC ESR: 00000000
[    8.851340] ... APIC ICR: 00000831
[    8.851340] ... APIC ICR: 00000831
[    8.851340] ... APIC ICR2: 01000000
[    8.851340] ... APIC ICR2: 01000000
[    8.851340] ... APIC LVTT: 000400ef
[    8.851340] ... APIC LVTT: 000400ef
[    8.851340] ... APIC LVTPC: 00000400
[    8.851340] ... APIC LVTPC: 00000400
[    8.851340] ... APIC LVT0: 00010700
[    8.851340] ... APIC LVT0: 00010700
[    8.851340] ... APIC LVT1: 00000400
[    8.851340] ... APIC LVT1: 00000400
[    8.851340] ... APIC LVTERR: 000000fe
[    8.851340] ... APIC LVTERR: 000000fe
[    8.851340] ... APIC TMICT: 00000000
[    8.851340] ... APIC TMICT: 00000000
[    8.851340] ... APIC TMCCT: 00000000
[    8.851340] ... APIC TMCCT: 00000000
[    8.851340] ... APIC TDCR: 00000000
[    8.851340] ... APIC TDCR: 00000000
[    8.851340]=20
[    8.851340]=20
[    8.931812] number of MP IRQ sources: 15.
[    8.931812] number of MP IRQ sources: 15.
[    8.943414] number of IO-APIC #0 registers: 24.
[    8.943414] number of IO-APIC #0 registers: 24.
[    8.945316] testing the IO APIC.......................
[    8.945316] testing the IO APIC.......................
[    8.947464] IO APIC #0......
[    8.947464] IO APIC #0......
[    8.948666] .... register #00: 00000000
[    8.948666] .... register #00: 00000000
[    8.950277] .......    : physical APIC id: 00
[    8.950277] .......    : physical APIC id: 00
[    8.952090] .......    : Delivery Type: 0
[    8.952090] .......    : Delivery Type: 0
[    8.963750] .......    : LTS          : 0
[    8.963750] .......    : LTS          : 0
[    8.965317] .... register #01: 00170011
[    8.965317] .... register #01: 00170011
[    8.966832] .......     : max redirection entries: 17
[    8.966832] .......     : max redirection entries: 17
[    8.968793] .......     : PRQ implemented: 0
[    8.968793] .......     : PRQ implemented: 0
[    8.970437] .......     : IO APIC version: 11
[    8.970437] .......     : IO APIC version: 11
[    8.972115] .... register #02: 00000000
[    8.972115] .... register #02: 00000000
[    8.983695] .......     : arbitration: 00
[    8.983695] .......     : arbitration: 00
[    8.985377] .... IRQ redirection table:
[    8.985377] .... IRQ redirection table:
[    8.987003] 1    0    0   0   0    0    0    00
[    8.987003] 1    0    0   0   0    0    0    00
[    8.988907] 0    0    0   0   0    1    1    31
[    8.988907] 0    0    0   0   0    1    1    31
[    8.990801] 0    0    0   0   0    1    1    30
[    8.990801] 0    0    0   0   0    1    1    30
[    8.992699] 0    0    0   0   0    1    1    33
[    8.992699] 0    0    0   0   0    1    1    33
[    9.004559] 1    0    0   0   0    1    1    34
[    9.004559] 1    0    0   0   0    1    1    34
[    9.006332] 1    1    0   0   0    1    1    35
[    9.006332] 1    1    0   0   0    1    1    35
[    9.008102] 0    0    0   0   0    1    1    36
[    9.008102] 0    0    0   0   0    1    1    36
[    9.009791] 0    0    0   0   0    1    1    37
[    9.009791] 0    0    0   0   0    1    1    37
[    9.011536] 0    0    0   0   0    1    1    38
[    9.011536] 0    0    0   0   0    1    1    38
[    9.023356] 0    1    0   0   0    1    1    39
[    9.023356] 0    1    0   0   0    1    1    39
[    9.025260] 1    1    0   0   0    1    1    3A
[    9.025260] 1    1    0   0   0    1    1    3A
[    9.027155] 1    1    0   0   0    1    1    3B
[    9.027155] 1    1    0   0   0    1    1    3B
[    9.029045] 0    0    0   0   0    1    1    3C
[    9.029045] 0    0    0   0   0    1    1    3C
[    9.030932] 0    0    0   0   0    1    1    3D
[    9.030932] 0    0    0   0   0    1    1    3D
[    9.032828] 0    0    0   0   0    1    1    3E
[    9.032828] 0    0    0   0   0    1    1    3E
[    9.044676] 0    0    0   0   0    1    1    3F
[    9.044676] 0    0    0   0   0    1    1    3F
[    9.046428] 1    0    0   0   0    0    0    00
[    9.046428] 1    0    0   0   0    0    0    00
[    9.048210] 1    0    0   0   0    0    0    00
[    9.048210] 1    0    0   0   0    0    0    00
[    9.049976] 1    0    0   0   0    0    0    00
[    9.049976] 1    0    0   0   0    0    0    00
[    9.051727] 1    0    0   0   0    0    0    00
[    9.051727] 1    0    0   0   0    0    0    00
[    9.055252] 1    0    0   0   0    0    0    00
[    9.055252] 1    0    0   0   0    0    0    00
[    9.057118] 1    0    0   0   0    0    0    00
[    9.057118] 1    0    0   0   0    0    0    00
[    9.058964] 1    0    0   0   0    0    0    00
[    9.058964] 1    0    0   0   0    0    0    00
[    9.073876] 1    0    0   0   0    0    0    00
[    9.073876] 1    0    0   0   0    0    0    00
[    9.075819] IRQ to pin mappings:
[    9.075819] IRQ to pin mappings:
[    9.077219] IRQ0=20
[    9.077219] IRQ0 -> 0:2-> 0:2

[    9.078343] IRQ1=20
[    9.078343] IRQ1 -> 0:1-> 0:1

[    9.079465] IRQ3=20
[    9.079465] IRQ3 -> 0:3-> 0:3

[    9.080584] IRQ4=20
[    9.080584] IRQ4 -> 0:4-> 0:4

[    9.081704] IRQ5=20
[    9.081704] IRQ5 -> 0:5-> 0:5

[    9.082816] IRQ6=20
[    9.082816] IRQ6 -> 0:6-> 0:6

[    9.093122] IRQ7=20
[    9.093122] IRQ7 -> 0:7-> 0:7

[    9.094258] IRQ8=20
[    9.094258] IRQ8 -> 0:8-> 0:8

[    9.095376] IRQ9=20
[    9.095376] IRQ9 -> 0:9-> 0:9

[    9.096495] IRQ10=20
[    9.096495] IRQ10 -> 0:10-> 0:10

[    9.097680] IRQ11=20
[    9.097680] IRQ11 -> 0:11-> 0:11

[    9.098870] IRQ12=20
[    9.098870] IRQ12 -> 0:12-> 0:12

[    9.100080] IRQ13=20
[    9.100080] IRQ13 -> 0:13-> 0:13

[    9.101269] IRQ14=20
[    9.101269] IRQ14 -> 0:14-> 0:14

[    9.102450] IRQ15=20
[    9.102450] IRQ15 -> 0:15-> 0:15

[    9.103619] .................................... done.
[    9.103619] .................................... done.
[    9.115361] bootconsole [earlyser0] disabled
[    9.115361] bootconsole [earlyser0] disabled
[    9.122136] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    9.132325] EDD information not available.
[    9.134764] debug: unmapping init [mem 0xffffffff81e4d000-0xffffffff81f1=
ffff]
[    9.152261] random: init urandom read with 3 bits of entropy available
[    9.206921] hostname (134) used greatest stack depth: 14000 bytes left
[    9.298401] grep (137) used greatest stack depth: 13560 bytes left
[    9.460950] mountall (143) used greatest stack depth: 13552 bytes left
mountall: Event failed
[    9.750309] init: Failed to create pty - disabling logging for job
[    9.764652] init: Temporary process spawn error: No such file or directo=
ry
[    9.808126] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
[    9.809013] CPU: 0 PID: 162 Comm: mount Not tainted 3.16.0-10291-g89f7ca=
1 #1
[    9.809013] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    9.809013] task: ffff88000bb36000 ti: ffff88000bb50000 task.ti: ffff880=
00bb50000
[    9.809013] RIP: 0010:[<ffffffff811a81d6>]  [<ffffffff811a81d6>] filesys=
tems_proc_show+0xa/0x8d
[    9.809013] RSP: 0018:ffff88000bb53e88  EFLAGS: 00010203
[    9.809013] RAX: ffff88000bb3f7dd RBX: 0000000000000000 RCX: 800000000bb=
8c060
[    9.809013] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88000bb=
3f728
[    9.809013] RBP: ffff88000bb53ef0 R08: 0000000000000001 R09: 00000000000=
0bb8c
[    9.809013] R10: 0000000000000000 R11: 0000000000000222 R12: 00000000000=
00400
[    9.809013] R13: ffff88000bb53f58 R14: ffff88000bb3f728 R15: ffff88000bb=
9c800
[    9.809013] FS:  00007fd52c855800(0000) GS:ffffffff81b7c000(0000) knlGS:=
0000000000000000
[    9.809013] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    9.809013] CR2: 0000000000618008 CR3: 000000000bbfe000 CR4: 00000000000=
406b0
[    9.809013] Stack:
[    9.809013]  ffff88000bb53ef0 ffffffff811aef31 ffff88000bb36488 00000000=
00000001
[    9.809013]  ffff88000bb3f768 00007fd52c85b000 0000000000000000 ffff8800=
0bb53ee8
[    9.809013]  ffff88000c36aa50 00007fd52c85b000 ffff88000bb53f58 00000000=
00000000
[    9.809013] Call Trace:
[    9.809013]  [<ffffffff811aef31>] ? seq_read+0x1dc/0x4a4
[    9.809013]  [<ffffffff811cfd6f>] proc_reg_read+0x5a/0x9b
[    9.809013]  [<ffffffff811cfd15>] ? proc_reg_write+0x9b/0x9b
[    9.809013]  [<ffffffff81182783>] vfs_read+0xad/0x129
[    9.809013]  [<ffffffff81182c07>] SyS_read+0x5e/0xcf
[    9.809013]  [<ffffffff8172e111>] tracesys+0xd3/0xd8
[    9.809013] Code: 31 d2 48 c7 c6 cc 81 1a 81 48 ff 05 05 62 b3 01 48 89 =
e5 e8 ad 77 00 00 48 ff 05 fe 61 b3 01 5d c3 55 48 ff 05 bc 61 b3 01 b0 dd =
<60> 0d 00 88 ff ff 48 c7 c7 c0 db c0 81 53 e8 60 4e 58 00 48 8b=20
[    9.809013] RIP  [<ffffffff811a81d6>] filesystems_proc_show+0xa/0x8d
[    9.809013]  RSP <ffff88000bb53e88>
[    9.883837] ---[ end trace 4f22e95511a0a94c ]---
mountall: mount /dev/pts [162] killed by SEGV signal
mountall: Filesystem could not be mounted: /dev/pts
mountall: Skipping mounting /dev/pts since Plymouth is not available
[    9.890282] init: Failed to create pty - disabling logging for job
[    9.891637] init: Temporary process spawn error: No such file or directo=
ry
[    9.966591] invalid opcode: 0000 [#2] DEBUG_PAGEALLOC
[    9.967506] CPU: 0 PID: 170 Comm: mount Tainted: G      D        3.16.0-=
10291-g89f7ca1 #1
[    9.967506] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    9.967506] task: ffff88000bbac000 ti: ffff88000bb80000 task.ti: ffff880=
00bb80000
[    9.967506] RIP: 0010:[<ffffffff811a81d6>]  [<ffffffff811a81d6>] filesys=
tems_proc_show+0xa/0x8d
[    9.967506] RSP: 0018:ffff88000bb83e88  EFLAGS: 00010207
[    9.967506] RAX: ffff88000bbff1dd RBX: 0000000000000000 RCX: 800000000bb=
ba060
[    9.967506] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88000bb=
ff418
[    9.967506] RBP: ffff88000bb83ef0 R08: 0000000000000001 R09: 00000000000=
0bbba
[    9.967506] R10: 000000000000025a R11: 000000000000023a R12: 00000000000=
00400
[    9.967506] R13: ffff88000bb83f58 R14: ffff88000bbff418 R15: ffff88000d5=
f8a40
[    9.967506] FS:  00007fe840849800(0000) GS:ffffffff81b7c000(0000) knlGS:=
0000000000000000
[    9.967506] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    9.967506] CR2: 0000000000618008 CR3: 000000000bbd6000 CR4: 00000000000=
406b0
[    9.967506] Stack:
[    9.967506]  ffff88000bb83ef0 ffffffff811aef31 ffff88000bbac488 00000000=
00000001
[    9.967506]  ffff88000bbff458 00007fe84084f000 0000000000000000 ffff8800=
0bb83ed8
[    9.967506]  ffff88000c36aa50 00007fe84084f000 ffff88000bb83f58 00000000=
00000000
[    9.967506] Call Trace:
[    9.967506]  [<ffffffff811aef31>] ? seq_read+0x1dc/0x4a4
[    9.967506]  [<ffffffff811cfd6f>] proc_reg_read+0x5a/0x9b
[    9.967506]  [<ffffffff811cfd15>] ? proc_reg_write+0x9b/0x9b
[    9.967506]  [<ffffffff81182783>] vfs_read+0xad/0x129
[    9.967506]  [<ffffffff81182c07>] SyS_read+0x5e/0xcf
[    9.967506]  [<ffffffff8172e111>] tracesys+0xd3/0xd8
[    9.967506] Code: 31 d2 48 c7 c6 cc 81 1a 81 48 ff 05 05 62 b3 01 48 89 =
e5 e8 ad 77 00 00 48 ff 05 fe 61 b3 01 5d c3 55 48 ff 05 bc 61 b3 01 b0 dd =
<60> 0d 00 88 ff ff 48 c7 c7 c0 db c0 81 53 e8 60 4e 58 00 48 8b=20
[    9.967506] RIP  [<ffffffff811a81d6>] filesystems_proc_show+0xa/0x8d
[    9.967506]  RSP <ffff88000bb83e88>
[   10.033272] ---[ end trace 4f22e95511a0a94d ]---
[   10.035446] init: mounted-tmp main process (163) terminated with status =
139
mountall: Event failed
[   10.050292] invalid opcode: 0000 [#3] DEBUG_PAGEALLOC
[   10.051009] CPU: 0 PID: 171 Comm: mount Tainted: G      D        3.16.0-=
10291-g89f7ca1 #1
[   10.051009] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   10.051009] task: ffff88000bb36000 ti: ffff88000bb50000 task.ti: ffff880=
00bb50000
[   10.051009] RIP: 0010:[<ffffffff811a81d6>]  [<ffffffff811a81d6>] filesys=
tems_proc_show+0xa/0x8d
[   10.051009] RSP: 0018:ffff88000bb53e88  EFLAGS: 00010203
[   10.051009] RAX: ffff88000bb3f5dd RBX: 0000000000000000 RCX: 800000000bb=
46060
[   10.051009] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88000bb=
3f618
[   10.051009] RBP: ffff88000bb53ef0 R08: 0000000000000001 R09: 00000000000=
0bb46
[   10.051009] R10: 000000000000025a R11: 000000000000023d R12: 00000000000=
00400
[   10.051009] R13: ffff88000bb53f58 R14: ffff88000bb3f618 R15: ffff88000bb=
8a680
[   10.051009] FS:  00007f8c78b9f800(0000) GS:ffffffff81b7c000(0000) knlGS:=
0000000000000000
[   10.051009] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   10.051009] CR2: 0000000000618008 CR3: 000000000bb97000 CR4: 00000000000=
406b0
[   10.051009] Stack:
[   10.051009]  ffff88000bb53ef0 ffffffff811aef31 ffff88000bb36488 00000000=
00000001
[   10.051009]  ffff88000bb3f658 00007f8c78ba5000 0000000000000000 ffff8800=
0bb53ed8
[   10.051009]  ffff88000c36aa50 00007f8c78ba5000 ffff88000bb53f58 00000000=
00000000
[   10.051009] Call Trace:
[   10.051009]  [<ffffffff811aef31>] ? seq_read+0x1dc/0x4a4
[   10.051009]  [<ffffffff811cfd6f>] proc_reg_read+0x5a/0x9b
[   10.051009]  [<ffffffff811cfd15>] ? proc_reg_write+0x9b/0x9b
[   10.051009]  [<ffffffff81182783>] vfs_read+0xad/0x129
[   10.051009]  [<ffffffff81182c07>] SyS_read+0x5e/0xcf
[   10.051009]  [<ffffffff8172e111>] tracesys+0xd3/0xd8
[   10.051009] Code: 31 d2 48 c7 c6 cc 81 1a 81 48 ff 05 05 62 b3 01 48 89 =
e5 e8 ad 77 00 00 48 ff 05 fe 61 b3 01 5d c3 55 48 ff 05 bc 61 b3 01 b0 dd =
<60> 0d 00 88 ff ff 48 c7 c7 c0 db c0 81 53 e8 60 4e 58 00 48 8b=20
[   10.051009] RIP  [<ffffffff811a81d6>] filesystems_proc_show+0xa/0x8d
[   10.051009]  RSP <ffff88000bb53e88>
[   10.130070] ---[ end trace 4f22e95511a0a94e ]---
mountall: mount /run [171] killed by SEGV signal
mountall: Filesystem could not be mounted: /run
mountall: Skipping mounting /run since Plymouth is not available
[   10.145446] init: Failed to create pty - disabling logging for job
[   10.146853] init: Temporary process spawn error: No such file or directo=
ry
[   10.164634] init: Failed to create pty - disabling logging for job
[   10.166113] init: Temporary process spawn error: No such file or directo=
ry
[   10.182259] init: Failed to create pty - disabling logging for job
[   10.184323] init: Temporary process spawn error: No such file or directo=
ry
[   10.198127] init: Failed to create pty - disabling logging for job
[   10.202129] init: Temporary process spawn error: No such file or directo=
ry
[   10.238716] init: Failed to create pty - disabling logging for job
[   10.257743] invalid opcode: 0000 [#4] DEBUG_PAGEALLOC
[   10.258010] CPU: 0 PID: 180 Comm: udevd Tainted: G      D        3.16.0-=
10291-g89f7ca1 #1
[   10.258010] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   10.258010] task: ffff88000bb48000 ti: ffff88000bbe0000 task.ti: ffff880=
00bbe0000
[   10.258010] RIP: 0010:[<ffffffff811a81d6>]  [<ffffffff811a81d6>] filesys=
tems_proc_show+0xa/0x8d
[   10.258010] RSP: 0018:ffff88000bbe3e88  EFLAGS: 00010203
[   10.258010] RAX: ffff88000bba06dd RBX: 0000000000000000 RCX: 800000000bb=
97060
[   10.258010] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88000bb=
a0808
[   10.258010] RBP: ffff88000bbe3ef0 R08: 0000000000000001 R09: 00000000000=
0bb97
[   10.258010] R10: 000000000000025a R11: 000000000000025b R12: 00000000000=
00400
[   10.258010] R13: ffff88000bbe3f58 R14: ffff88000bba0808 R15: ffff88000b4=
129c0
[   10.258010] FS:  00007f8daefcb7c0(0000) GS:ffffffff81b7c000(0000) knlGS:=
0000000000000000
[   10.258010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   10.258010] CR2: 00007f8daf1f8008 CR3: 000000000baec000 CR4: 00000000000=
406b0
[   10.258010] Stack:
[   10.258010]  ffff88000bbe3ef0 ffffffff811aef31 ffff88000bb48488 00000000=
00000001
[   10.258010]  ffff88000bba0848 00007f8daefd0000 0000000000000000 ffff8800=
0bbe3ed8
[   10.258010]  ffff88000c36aa50 00007f8daefd0000 ffff88000bbe3f58 00000000=
00000000
[   10.258010] Call Trace:
[   10.258010]  [<ffffffff811aef31>] ? seq_read+0x1dc/0x4a4
[   10.258010]  [<ffffffff811cfd6f>] proc_reg_read+0x5a/0x9b
[   10.258010]  [<ffffffff811cfd15>] ? proc_reg_write+0x9b/0x9b
[   10.258010]  [<ffffffff81182783>] vfs_read+0xad/0x129
[   10.258010]  [<ffffffff81182c07>] SyS_read+0x5e/0xcf
[   10.258010]  [<ffffffff8172e111>] tracesys+0xd3/0xd8
[   10.258010] Code: 31 d2 48 c7 c6 cc 81 1a 81 48 ff 05 05 62 b3 01 48 89 =
e5 e8 ad 77 00 00 48 ff 05 fe 61 b3 01 5d c3 55 48 ff 05 bc 61 b3 01 b0 dd =
<60> 0d 00 88 ff ff 48 c7 c7 c0 db c0 81 53 e8 60 4e 58 00 48 8b=20
[   10.258010] RIP  [<ffffffff811a81d6>] filesystems_proc_show+0xa/0x8d
[   10.258010]  RSP <ffff88000bbe3e88>
[   10.336388] ---[ end trace 4f22e95511a0a94f ]---
[   10.355546] init: udev main process (180) killed by SEGV signal
[   10.357063] init: udev main process ended, respawning
[   10.359842] init: Failed to create pty - disabling logging for job
[   10.361290] init: Temporary process spawn error: No such file or directo=
ry
[   63.499054] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[   69.505024] init: Failed to create pty - disabling logging for job
[   69.551323] init: Temporary process spawn error: No such file or directo=
ry
[   69.612784] init: plymouth-upstart-bridge main process (193) terminated =
with status 1
[   69.656331] init: hwclock-save main process (192) terminated with status=
 70
[   69.790039] invalid opcode: 0000 [#5] DEBUG_PAGEALLOC
[   69.790936] CPU: 0 PID: 199 Comm: sed Tainted: G      D        3.16.0-10=
291-g89f7ca1 #1
[   69.791011] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   69.791011] task: ffff88000bbbe000 ti: ffff88000bad4000 task.ti: ffff880=
00bad4000
[   69.791011] RIP: 0010:[<ffffffff811a81d6>]  [<ffffffff811a81d6>] filesys=
tems_proc_show+0xa/0x8d
[   69.791011] RSP: 0018:ffff88000bad7e88  EFLAGS: 00010207
[   69.791011] RAX: ffff88000b4129dd RBX: 0000000000000000 RCX: 800000000bb=
fc060
[   69.791011] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88000b4=
12980
[   69.791011] RBP: ffff88000bad7ef0 R08: 0000000000000001 R09: 00000000000=
0bbfc
[   69.791011] R10: 000000000000025a R11: 0000000000000293 R12: 00000000000=
00400
[   69.791011] R13: ffff88000bad7f58 R14: ffff88000b412980 R15: ffff88000d6=
bc940
[   69.791011] FS:  00007fd5f1f9f7c0(0000) GS:ffffffff81b7c000(0000) knlGS:=
0000000000000000
[   69.791011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   69.791011] CR2: 0000000000619008 CR3: 000000000b427000 CR4: 00000000000=
406b0
[   69.791011] Stack:
[   69.791011]  ffff88000bad7ef0 ffffffff811aef31 ffff88000bbbe488 00000000=
00000001
[   69.791011]  ffff88000b4129c0 00007fd5f1fa3000 0000000000000000 ffff8800=
0bad7ed8
[   69.791011]  ffff88000c36aa50 00007fd5f1fa3000 ffff88000bad7f58 00000000=
00000000
[   69.791011] Call Trace:
[   69.791011]  [<ffffffff811aef31>] ? seq_read+0x1dc/0x4a4
[   69.791011]  [<ffffffff811cfd6f>] proc_reg_read+0x5a/0x9b
[   69.791011]  [<ffffffff811cfd15>] ? proc_reg_write+0x9b/0x9b
[   69.791011]  [<ffffffff81182783>] vfs_read+0xad/0x129
[   69.791011]  [<ffffffff81182c07>] SyS_read+0x5e/0xcf
[   69.791011]  [<ffffffff8172e111>] tracesys+0xd3/0xd8
[   69.791011] Code: 31 d2 48 c7 c6 cc 81 1a 81 48 ff 05 05 62 b3 01 48 89 =
e5 e8 ad 77 00 00 48 ff 05 fe 61 b3 01 5d c3 55 48 ff 05 bc 61 b3 01 b0 dd =
<60> 0d 00 88 ff ff 48 c7 c7 c0 db c0 81 53 e8 60 4e 58 00 48 8b=20
[   69.791011] RIP  [<ffffffff811a81d6>] filesystems_proc_show+0xa/0x8d
[   69.791011]  RSP <ffff88000bad7e88>
[   69.921024] ---[ end trace 4f22e95511a0a950 ]---
[   70.099136] invalid opcode: 0000 [#6] DEBUG_PAGEALLOC
[   70.100009] CPU: 0 PID: 215 Comm: sed Tainted: G      D        3.16.0-10=
291-g89f7ca1 #1
[   70.100009] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   70.100009] task: ffff88000bb0e000 ti: ffff88000bb00000 task.ti: ffff880=
00bb00000
[   70.100009] RIP: 0010:[<ffffffff811a81d6>]  [<ffffffff811a81d6>] filesys=
tems_proc_show+0xa/0x8d
[   70.100009] RSP: 0018:ffff88000bb03e88  EFLAGS: 00010213
[   70.100009] RAX: ffff88000bba85dd RBX: 0000000000000000 RCX: 800000000bb=
66060
[   70.100009] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88000bb=
a8e38
[   70.100009] RBP: ffff88000bb03ef0 R08: 0000000000000001 R09: 00000000000=
0bb66
[   70.100009] R10: 000000000000025a R11: 00000000000002c3 R12: 00000000000=
00400
[   70.100009] R13: ffff88000bb03f58 R14: ffff88000bba8e38 R15: ffff88000d6=
40e00
[   70.100009] FS:  00007f4889ae77c0(0000) GS:ffffffff81b7c000(0000) knlGS:=
0000000000000000
[   70.100009] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   70.100009] CR2: 00007f488938fad0 CR3: 000000000bb92000 CR4: 00000000000=
406b0
[   70.100009] Stack:
[   70.100009]  ffff88000bb03ef0 ffffffff811aef31 ffff88000bb0e488 00000000=
00000001
[   70.100009]  ffff88000bba8e78 00007f4889aeb000 0000000000000000 ffff8800=
0bb03ed8
[   70.100009]  ffff88000c36aa50 00007f4889aeb000 ffff88000bb03f58 00000000=
00000000
[   70.100009] Call Trace:
[   70.100009]  [<ffffffff811aef31>] ? seq_read+0x1dc/0x4a4
[   70.100009]  [<ffffffff811cfd6f>] proc_reg_read+0x5a/0x9b
[   70.100009]  [<ffffffff811cfd15>] ? proc_reg_write+0x9b/0x9b
[   70.100009]  [<ffffffff81182783>] vfs_read+0xad/0x129
[   70.100009]  [<ffffffff81182c07>] SyS_read+0x5e/0xcf
[   70.100009]  [<ffffffff8172e111>] tracesys+0xd3/0xd8
[   70.100009] Code: 31 d2 48 c7 c6 cc 81 1a 81 48 ff 05 05 62 b3 01 48 89 =
e5 e8 ad 77 00 00 48 ff 05 fe 61 b3 01 5d c3 55 48 ff 05 bc 61 b3 01 b0 dd =
<60> 0d 00 88 ff ff 48 c7 c7 c0 db c0 81 53 e8 60 4e 58 00 48 8b=20
[   70.100009] RIP  [<ffffffff811a81d6>] filesystems_proc_show+0xa/0x8d
[   70.100009]  RSP <ffff88000bb03e88>
[   70.183748] ---[ end trace 4f22e95511a0a951 ]---
[   70.533315] invalid opcode: 0000 [#7] DEBUG_PAGEALLOC
[   70.534014] CPU: 0 PID: 246 Comm: sed Tainted: G      D        3.16.0-10=
291-g89f7ca1 #1
[   70.534014] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   70.534014] task: ffff88000bb62000 ti: ffff88000bb74000 task.ti: ffff880=
00bb74000
[   70.534014] RIP: 0010:[<ffffffff811a81d6>]  [<ffffffff811a81d6>] filesys=
tems_proc_show+0xa/0x8d
[   70.534014] RSP: 0018:ffff88000bb77e88  EFLAGS: 00010207
[   70.534014] RAX: ffff88000bace7dd RBX: 0000000000000000 RCX: 80000000111=
93060
[   70.534014] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88000ba=
cecc8
[   70.534014] RBP: ffff88000bb77ef0 R08: 0000000000000001 R09: 00000000000=
11193
[   70.534014] R10: 000000000000025a R11: 0000000000000320 R12: 00000000000=
00400
[   70.534014] R13: ffff88000bb77f58 R14: ffff88000bacecc8 R15: ffff88000e5=
d05c0
[   70.534014] FS:  00007f279b7507c0(0000) GS:ffffffff81b7c000(0000) knlGS:=
0000000000000000
[   70.534014] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   70.534014] CR2: 0000000000619008 CR3: 000000000bbaa000 CR4: 00000000000=
406b0
[   70.534014] Stack:
[   70.534014]  ffff88000bb77ef0 ffffffff811aef31 ffff88000bb62488 00000000=
00000001
[   70.534014]  ffff88000baced08 00007f279b754000 0000000000000000 ffff8800=
0bb77ed8
[   70.534014]  ffff88000c36aa50 00007f279b754000 ffff88000bb77f58 00000000=
00000000
[   70.534014] Call Trace:
[   70.534014]  [<ffffffff811aef31>] ? seq_read+0x1dc/0x4a4
[   70.534014]  [<ffffffff811cfd6f>] proc_reg_read+0x5a/0x9b
[   70.534014]  [<ffffffff811cfd15>] ? proc_reg_write+0x9b/0x9b
[   70.534014]  [<ffffffff81182783>] vfs_read+0xad/0x129
[   70.534014]  [<ffffffff81182c07>] SyS_read+0x5e/0xcf
[   70.534014]  [<ffffffff8172e111>] tracesys+0xd3/0xd8
[   70.534014] Code: 31 d2 48 c7 c6 cc 81 1a 81 48 ff 05 05 62 b3 01 48 89 =
e5 e8 ad 77 00 00 48 ff 05 fe 61 b3 01 5d c3 55 48 ff 05 bc 61 b3 01 b0 dd =
<60> 0d 00 88 ff ff 48 c7 c7 c0 db c0 81 53 e8 60 4e 58 00 48 8b=20
[   70.534014] RIP  [<ffffffff811a81d6>] filesystems_proc_show+0xa/0x8d
[   70.534014]  RSP <ffff88000bb77e88>
[   70.611127] ---[ end trace 4f22e95511a0a952 ]---
[   70.839180] init: Re-executing /init
[   71.891445] invalid opcode: 0000 [#8] DEBUG_PAGEALLOC
[   71.892114] CPU: 0 PID: 283 Comm: mkdir Tainted: G      D        3.16.0-=
10291-g89f7ca1 #1
[   71.892114] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   71.892114] task: ffff88000bb92000 ti: ffff88000bbdc000 task.ti: ffff880=
00bbdc000
[   71.892114] RIP: 0010:[<ffffffff811a81d6>]  [<ffffffff811a81d6>] filesys=
tems_proc_show+0xa/0x8d
[   71.892114] RSP: 0018:ffff88000bbdfe88  EFLAGS: 00010207
[   71.892114] RAX: ffff88000bbdbddd RBX: 0000000000000000 RCX: 800000000ba=
b7060
[   71.892114] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88000bb=
dbe20
[   71.892114] RBP: ffff88000bbdfef0 R08: 0000000000000001 R09: 00000000000=
0bab7
[   71.892114] R10: 000000000000025a R11: 000000000000038f R12: 00000000000=
00400
[   71.892114] R13: ffff88000bbdff58 R14: ffff88000bbdbe20 R15: ffff88000ba=
c54c0
[   71.892114] FS:  00007feb760cd7c0(0000) GS:ffffffff81b7c000(0000) knlGS:=
0000000000000000
[   71.892114] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   71.892114] CR2: 000000000060c008 CR3: 000000000baab000 CR4: 00000000000=
406b0
[   71.892114] Stack:
[   71.892114]  ffff88000bbdfef0 ffffffff811aef31 ffff88000bb92488 00000000=
00000001
[   71.892114]  ffff88000bbdbe60 00007feb760d1000 0000000000000000 ffff8800=
0bbdfed8
[   71.892114]  ffff88000c36aa50 00007feb760d1000 ffff88000bbdff58 00000000=
00000000
[   71.892114] Call Trace:
[   71.892114]  [<ffffffff811aef31>] ? seq_read+0x1dc/0x4a4
[   71.892114]  [<ffffffff811cfd6f>] proc_reg_read+0x5a/0x9b
[   71.892114]  [<ffffffff811cfd15>] ? proc_reg_write+0x9b/0x9b
[   71.892114]  [<ffffffff81182783>] vfs_read+0xad/0x129
[   71.892114]  [<ffffffff81182c07>] SyS_read+0x5e/0xcf
[   71.892114]  [<ffffffff8172e111>] tracesys+0xd3/0xd8
[   71.892114] Code: 31 d2 48 c7 c6 cc 81 1a 81 48 ff 05 05 62 b3 01 48 89 =
e5 e8 ad 77 00 00 48 ff 05 fe 61 b3 01 5d c3 55 48 ff 05 bc 61 b3 01 b0 dd =
<60> 0d 00 88 ff ff 48 c7 c7 c0 db c0 81 53 e8 60 4e 58 00 48 8b=20
[   71.892114] RIP  [<ffffffff811a81d6>] filesystems_proc_show+0xa/0x8d
[   71.892114]  RSP <ffff88000bbdfe88>
[   72.010368] ---[ end trace 4f22e95511a0a953 ]---
/etc/rc6.d/S60umountroot: line 51:   283 Segmentation fault      mkdir -p $=
dir
[   72.024732] invalid opcode: 0000 [#9] DEBUG_PAGEALLOC
[   72.025150] CPU: 0 PID: 284 Comm: mkdir Tainted: G      D        3.16.0-=
10291-g89f7ca1 #1
[   72.025150] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   72.025150] task: ffff88000bab4000 ti: ffff88000bab8000 task.ti: ffff880=
00bab8000
[   72.025150] RIP: 0010:[<ffffffff811a81d6>]  [<ffffffff811a81d6>] filesys=
tems_proc_show+0xa/0x8d
[   72.025150] RSP: 0018:ffff88000babbe88  EFLAGS: 00010203
[   72.025150] RAX: ffff88000bb6bcdd RBX: 0000000000000000 RCX: 800000000ba=
b6060
[   72.025150] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88000bb=
6bca0
[   72.025150] RBP: ffff88000babbef0 R08: 0000000000000001 R09: 00000000000=
0bab6
[   72.025150] R10: 000000000000025a R11: 0000000000000392 R12: 00000000000=
00400
[   72.025150] R13: ffff88000babbf58 R14: ffff88000bb6bca0 R15: ffff88000bb=
7bd40
[   72.025150] FS:  00007fb034d607c0(0000) GS:ffffffff81b7c000(0000) knlGS:=
0000000000000000
[   72.025150] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   72.025150] CR2: 000000000060c008 CR3: 000000000bb43000 CR4: 00000000000=
406b0
[   72.025150] Stack:
[   72.025150]  ffff88000babbef0 ffffffff811aef31 ffff88000bab4488 00000000=
00000001
[   72.025150]  ffff88000bb6bce0 00007fb034d64000 0000000000000000 ffff8800=
0babbed8
[   72.025150]  ffff88000c36aa50 00007fb034d64000 ffff88000babbf58 00000000=
00000000
[   72.025150] Call Trace:
[   72.025150]  [<ffffffff811aef31>] ? seq_read+0x1dc/0x4a4
[   72.025150]  [<ffffffff811cfd6f>] proc_reg_read+0x5a/0x9b
[   72.025150]  [<ffffffff811cfd15>] ? proc_reg_write+0x9b/0x9b
[   72.025150]  [<ffffffff81182783>] vfs_read+0xad/0x129
[   72.025150]  [<ffffffff81182c07>] SyS_read+0x5e/0xcf
[   72.025150]  [<ffffffff8172e111>] tracesys+0xd3/0xd8
[   72.025150] Code: 31 d2 48 c7 c6 cc 81 1a 81 48 ff 05 05 62 b3 01 48 89 =
e5 e8 ad 77 00 00 48 ff 05 fe 61 b3 01 5d c3 55 48 ff 05 bc 61 b3 01 b0 dd =
<60> 0d 00 88 ff ff 48 c7 c7 c0 db c0 81 53 e8 60 4e 58 00 48 8b=20
[   72.025150] RIP  [<ffffffff811a81d6>] filesystems_proc_show+0xa/0x8d
[   72.025150]  RSP <ffff88000babbe88>
[   72.131896] ---[ end trace 4f22e95511a0a954 ]---
/etc/rc6.d/S60umountroot: line 51:   284 Segmentation fault      mkdir -p $=
dir
[   72.138981] invalid opcode: 0000 [#10] DEBUG_PAGEALLOC
[   72.139010] CPU: 0 PID: 285 Comm: umount Tainted: G      D        3.16.0=
-10291-g89f7ca1 #1
[   72.139010] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   72.139010] task: ffff88000bab4000 ti: ffff88000bab8000 task.ti: ffff880=
00bab8000
[   72.139010] RIP: 0010:[<ffffffff811a81d6>]  [<ffffffff811a81d6>] filesys=
tems_proc_show+0xa/0x8d
[   72.139010] RSP: 0018:ffff88000babbe88  EFLAGS: 00010207
[   72.139010] RAX: ffff88000bbdbddd RBX: 0000000000000000 RCX: 800000000bb=
86060
[   72.139010] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88000bb=
dbd70
[   72.139010] RBP: ffff88000babbef0 R08: 0000000000000001 R09: 00000000000=
0bb86
[   72.139010] R10: 000000000000025a R11: 0000000000000395 R12: 00000000000=
00400
[   72.139010] R13: ffff88000babbf58 R14: ffff88000bbdbd70 R15: ffff88000d7=
05380
[   72.139010] FS:  00007fb775c7b800(0000) GS:ffffffff81b7c000(0000) knlGS:=
0000000000000000
[   72.139010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   72.139010] CR2: 0000000000612008 CR3: 000000000bb7a000 CR4: 00000000000=
406b0
[   72.139010] Stack:
[   72.139010]  ffff88000babbef0 ffffffff811aef31 ffff88000bab4488 00000000=
00000001
[   72.139010]  ffff88000bbdbdb0 00007fb775c81000 0000000000000000 ffff8800=
0babbed8
[   72.139010]  ffff88000c36aa50 00007fb775c81000 ffff88000babbf58 00000000=
00000000
[   72.139010] Call Trace:
[   72.139010]  [<ffffffff811aef31>] ? seq_read+0x1dc/0x4a4
[   72.139010]  [<ffffffff811cfd6f>] proc_reg_read+0x5a/0x9b
[   72.139010]  [<ffffffff811cfd15>] ? proc_reg_write+0x9b/0x9b
[   72.139010]  [<ffffffff81182783>] vfs_read+0xad/0x129
[   72.139010]  [<ffffffff81182c07>] SyS_read+0x5e/0xcf
[   72.139010]  [<ffffffff8172e111>] tracesys+0xd3/0xd8
[   72.139010] Code: 31 d2 48 c7 c6 cc 81 1a 81 48 ff 05 05 62 b3 01 48 89 =
e5 e8 ad 77 00 00 48 ff 05 fe 61 b3 01 5d c3 55 48 ff 05 bc 61 b3 01 b0 dd =
<60> 0d 00 88 ff ff 48 c7 c7 c0 db c0 81 53 e8 60 4e 58 00 48 8b=20
[   72.139010] RIP  [<ffffffff811a81d6>] filesystems_proc_show+0xa/0x8d
[   72.139010]  RSP <ffff88000babbe88>
[   72.257896] ---[ end trace 4f22e95511a0a955 ]---
/etc/rc6.d/S60umountroot: line 17:   285 Segmentation fault      umount -l =
/var/run
[   72.269880] invalid opcode: 0000 [#11] DEBUG_PAGEALLOC
[   72.270010] CPU: 0 PID: 288 Comm: umount Tainted: G      D        3.16.0=
-10291-g89f7ca1 #1
[   72.270010] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   72.270010] task: ffff88000bab4000 ti: ffff88000bab8000 task.ti: ffff880=
00bab8000
[   72.270010] RIP: 0010:[<ffffffff811a81d6>]  [<ffffffff811a81d6>] filesys=
tems_proc_show+0xa/0x8d
[   72.270010] RSP: 0018:ffff88000babbe88  EFLAGS: 00010203
[   72.270010] RAX: ffff88000babeddd RBX: 0000000000000000 RCX: 800000000bb=
43060
[   72.270010] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88000ba=
bee38
[   72.270010] RBP: ffff88000babbef0 R08: 0000000000000001 R09: 00000000000=
0bb43
[   72.270010] R10: 000000000000025a R11: 000000000000039e R12: 00000000000=
00400
[   72.270010] R13: ffff88000babbf58 R14: ffff88000babee38 R15: ffff88000d1=
98940
[   72.270010] FS:  00007fab0a1a1800(0000) GS:ffffffff81b7c000(0000) knlGS:=
0000000000000000
[   72.270010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   72.270010] CR2: 0000000000612008 CR3: 000000000bb90000 CR4: 00000000000=
406b0
[   72.270010] Stack:
[   72.270010]  ffff88000babbef0 ffffffff811aef31 ffff88000bab4488 00000000=
00000001
[   72.270010]  ffff88000babee78 00007fab0a1a7000 0000000000000000 ffff8800=
0babbed8
[   72.270010]  ffff88000c36aa50 00007fab0a1a7000 ffff88000babbf58 00000000=
00000000
[   72.270010] Call Trace:
[   72.270010]  [<ffffffff811aef31>] ? seq_read+0x1dc/0x4a4
[   72.270010]  [<ffffffff811cfd6f>] proc_reg_read+0x5a/0x9b
[   72.270010]  [<ffffffff811cfd15>] ? proc_reg_write+0x9b/0x9b
[   72.270010]  [<ffffffff81182783>] vfs_read+0xad/0x129
[   72.270010]  [<ffffffff81182c07>] SyS_read+0x5e/0xcf
[   72.270010]  [<ffffffff8172e111>] tracesys+0xd3/0xd8
[   72.270010] Code: 31 d2 48 c7 c6 cc 81 1a 81 48 ff 05 05 62 b3 01 48 89 =
e5 e8 ad 77 00 00 48 ff 05 fe 61 b3 01 5d c3 55 48 ff 05 bc 61 b3 01 b0 dd =
<60> 0d 00 88 ff ff 48 c7 c7 c0 db c0 81 53 e8 60 4e 58 00 48 8b=20
[   72.270010] RIP  [<ffffffff811a81d6>] filesystems_proc_show+0xa/0x8d
[   72.270010]  RSP <ffff88000babbe88>
[   72.353811] ---[ end trace 4f22e95511a0a956 ]---
/etc/rc6.d/S60umountroot: line 17:   288 Segmentation fault      umount -l =
/var/lock
[   72.391261] invalid opcode: 0000 [#12] DEBUG_PAGEALLOC
[   72.392063] CPU: 0 PID: 293 Comm: mount Tainted: G      D        3.16.0-=
10291-g89f7ca1 #1
[   72.392063] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   72.392063] task: ffff88000bbea000 ti: ffff88000bbdc000 task.ti: ffff880=
00bbdc000
[   72.392063] RIP: 0010:[<ffffffff811a81d6>]  [<ffffffff811a81d6>] filesys=
tems_proc_show+0xa/0x8d
[   72.392063] RSP: 0018:ffff88000bbdfe88  EFLAGS: 00010203
[   72.392063] RAX: ffff88000bbdbddd RBX: 0000000000000000 RCX: 80000000100=
52060
[   72.392063] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88000bb=
dbd70
[   72.392063] RBP: ffff88000bbdfef0 R08: 0000000000000001 R09: 00000000000=
10052
[   72.392063] R10: 000000000000025a R11: 00000000000003ad R12: 00000000000=
00400
[   72.392063] R13: ffff88000bbdff58 R14: ffff88000bbdbd70 R15: ffff88000ba=
e33c0
[   72.392063] FS:  00007f8a89d83800(0000) GS:ffffffff81b7c000(0000) knlGS:=
0000000000000000
[   72.392063] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   72.392063] CR2: 0000000000618008 CR3: 000000000bad0000 CR4: 00000000000=
406b0
[   72.392063] Stack:
[   72.392063]  ffff88000bbdfef0 ffffffff811aef31 ffff88000bbea488 00000000=
00000001
[   72.392063]  ffff88000bbdbdb0 00007f8a89d89000 0000000000000000 ffff8800=
0bbdfed8
[   72.392063]  ffff88000c36aa50 00007f8a89d89000 ffff88000bbdff58 00000000=
00000000
[   72.392063] Call Trace:
[   72.392063]  [<ffffffff811aef31>] ? seq_read+0x1dc/0x4a4
[   72.392063]  [<ffffffff811cfd6f>] proc_reg_read+0x5a/0x9b
[   72.392063]  [<ffffffff811cfd15>] ? proc_reg_write+0x9b/0x9b
[   72.392063]  [<ffffffff81182783>] vfs_read+0xad/0x129
[   72.392063]  [<ffffffff81182c07>] SyS_read+0x5e/0xcf
[   72.392063]  [<ffffffff8172e111>] tracesys+0xd3/0xd8
[   72.392063] Code: 31 d2 48 c7 c6 cc 81 1a 81 48 ff 05 05 62 b3 01 48 89 =
e5 e8 ad 77 00 00 48 ff 05 fe 61 b3 01 5d c3 55 48 ff 05 bc 61 b3 01 b0 dd =
<60> 0d 00 88 ff ff 48 c7 c7 c0 db c0 81 53 e8 60 4e 58 00 48 8b=20
[   72.392063] RIP  [<ffffffff811a81d6>] filesystems_proc_show+0xa/0x8d
[   72.392063]  RSP <ffff88000bbdfe88>
[   72.458697] ---[ end trace 4f22e95511a0a957 ]---
/etc/rc6.d/S60umountroot: line 17:   293 Segmentation fault      mount $MOU=
NT_FORCE_OPT -n -o remount,ro -t dummytype dummydev / 2> /dev/null
[   72.475423] invalid opcode: 0000 [#13] DEBUG_PAGEALLOC
[   72.476009] CPU: 0 PID: 294 Comm: mount Tainted: G      D        3.16.0-=
10291-g89f7ca1 #1
[   72.476009] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   72.476009] task: ffff88000bbea000 ti: ffff88000bbdc000 task.ti: ffff880=
00bbdc000
[   72.476009] RIP: 0010:[<ffffffff811a81d6>]  [<ffffffff811a81d6>] filesys=
tems_proc_show+0xa/0x8d
[   72.476009] RSP: 0018:ffff88000bbdfe88  EFLAGS: 00010207
[   72.476009] RAX: ffff88000bb3bbdd RBX: 0000000000000000 RCX: 800000000ba=
ed060
[   72.476009] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88000bb=
3bbc8
[   72.476009] RBP: ffff88000bbdfef0 R08: 0000000000000001 R09: 00000000000=
0baed
[   72.476009] R10: 000000000000025a R11: 00000000000003b0 R12: 00000000000=
00400
[   72.476009] R13: ffff88000bbdff58 R14: ffff88000bb3bbc8 R15: ffff88000d7=
02380
[   72.476009] FS:  00007ff6f274b800(0000) GS:ffffffff81b7c000(0000) knlGS:=
0000000000000000
[   72.476009] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   72.476009] CR2: 0000000000618008 CR3: 000000000bb9b000 CR4: 00000000000=
406b0
[   72.476009] Stack:
[   72.476009]  ffff88000bbdfef0 ffffffff811aef31 ffff88000bbea488 00000000=
00000001
[   72.476009]  ffff88000bb3bc08 00007ff6f2751000 0000000000000000 ffff8800=
0bbdfed8
[   72.476009]  ffff88000c36aa50 00007ff6f2751000 ffff88000bbdff58 00000000=
00000000
[   72.476009] Call Trace:
[   72.476009]  [<ffffffff811aef31>] ? seq_read+0x1dc/0x4a4
[   72.476009]  [<ffffffff811cfd6f>] proc_reg_read+0x5a/0x9b
[   72.476009]  [<ffffffff811cfd15>] ? proc_reg_write+0x9b/0x9b
[   72.476009]  [<ffffffff81182783>] vfs_read+0xad/0x129
[   72.476009]  [<ffffffff81182c07>] SyS_read+0x5e/0xcf
[   72.476009]  [<ffffffff8172e111>] tracesys+0xd3/0xd8
[   72.476009] Code: 31 d2 48 c7 c6 cc 81 1a 81 48 ff 05 05 62 b3 01 48 89 =
e5 e8 ad 77 00 00 48 ff 05 fe 61 b3 01 5d c3 55 48 ff 05 bc 61 b3 01 b0 dd =
<60> 0d 00 88 ff ff 48 c7 c7 c0 db c0 81 53 e8 60 4e 58 00 48 8b=20
[   72.476009] RIP  [<ffffffff811a81d6>] filesystems_proc_show+0xa/0x8d
[   72.476009]  RSP <ffff88000bbdfe88>
[   72.541677] ---[ end trace 4f22e95511a0a958 ]---
/etc/rc6.d/S60umountroot: line 17:   294 Segmentation fault      mount $MOU=
NT_FORCE_OPT -n -o remount,ro dummydev / 2> /dev/null
[   72.557144] invalid opcode: 0000 [#14] DEBUG_PAGEALLOC
[   72.558053] CPU: 0 PID: 295 Comm: mount Tainted: G      D        3.16.0-=
10291-g89f7ca1 #1
[   72.558053] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   72.558053] task: ffff88000bab4000 ti: ffff88000bab8000 task.ti: ffff880=
00bab8000
[   72.558053] RIP: 0010:[<ffffffff811a81d6>]  [<ffffffff811a81d6>] filesys=
tems_proc_show+0xa/0x8d
[   72.558053] RSP: 0018:ffff88000babbe88  EFLAGS: 00010207
[   72.558053] RAX: ffff88000bac21dd RBX: 0000000000000000 RCX: 800000000bb=
da060
[   72.558053] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88000ba=
c21c0
[   72.558053] RBP: ffff88000babbef0 R08: 0000000000000001 R09: 00000000000=
0bbda
[   72.558053] R10: 000000000000025a R11: 00000000000003b3 R12: 00000000000=
00400
[   72.558053] R13: ffff88000babbf58 R14: ffff88000bac21c0 R15: ffff88000bb=
d6dc0
[   72.558053] FS:  00007f6978c8e800(0000) GS:ffffffff81b7c000(0000) knlGS:=
0000000000000000
[   72.558053] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   72.558053] CR2: 00007f697841fe37 CR3: 000000000bb8d000 CR4: 00000000000=
406b0
[   72.558053] Stack:
[   72.558053]  ffff88000babbef0 ffffffff811aef31 ffff88000bab4488 00000000=
00000001
[   72.558053]  ffff88000bac2200 00007f6978c94000 0000000000000000 ffff8800=
0babbed8
[   72.558053]  ffff88000c36aa50 00007f6978c94000 ffff88000babbf58 00000000=
00000000
[   72.558053] Call Trace:
[   72.558053]  [<ffffffff811aef31>] ? seq_read+0x1dc/0x4a4
[   72.558053]  [<ffffffff811cfd6f>] proc_reg_read+0x5a/0x9b
[   72.558053]  [<ffffffff811cfd15>] ? proc_reg_write+0x9b/0x9b
[   72.558053]  [<ffffffff81182783>] vfs_read+0xad/0x129
[   72.558053]  [<ffffffff81182c07>] SyS_read+0x5e/0xcf
[   72.558053]  [<ffffffff8172e111>] tracesys+0xd3/0xd8
[   72.558053] Code: 31 d2 48 c7 c6 cc 81 1a 81 48 ff 05 05 62 b3 01 48 89 =
e5 e8 ad 77 00 00 48 ff 05 fe 61 b3 01 5d c3 55 48 ff 05 bc 61 b3 01 b0 dd =
<60> 0d 00 88 ff ff 48 c7 c7 c0 db c0 81 53 e8 60 4e 58 00 48 8b=20
[   72.558053] RIP  [<ffffffff811a81d6>] filesystems_proc_show+0xa/0x8d
[   72.558053]  RSP <ffff88000babbe88>
[   72.633735] ---[ end trace 4f22e95511a0a959 ]---
/etc/rc6.d/S60umountroot: line 17:   295 Segmentation fault      mount $MOU=
NT_FORCE_OPT -n -o remount,ro /
 * Will now restart
[   72.660443] Unregister pv shared memory for cpu 0
[   72.671510] spin_lock-torture: Unscheduled system shutdown detected
[   72.672823] torture thread torture_stutter parking due to system shutdown
[   72.674228] torture thread torture_shuffle parking due to system shutdown
[   72.676326] reboot: Restarting system
[   72.677105] reboot: machine restart
Elapsed time: 85
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/x86=
_64-randconfig-ib1-08181713/89f7ca1af15bdfe7a6aed343032a84af2a69f736/vmlinu=
z-3.16.0-10291-g89f7ca1 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,11=
5200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D=
2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  ro=
ot=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-ib1-=
08181713/next:master:89f7ca1af15bdfe7a6aed343032a84af2a69f736:bisect-linux-=
4/.vmlinuz-89f7ca1af15bdfe7a6aed343032a84af2a69f736-20140819183912-100-kbui=
ld branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib1-08181713=
/89f7ca1af15bdfe7a6aed343032a84af2a69f736/vmlinuz-3.16.0-10291-g89f7ca1 drb=
d.minor_count=3D8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m=
 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm=
/kboot/pid-quantal-kbuild-5 -serial file:/dev/shm/kboot/serial-quantal-kbui=
ld-5 -daemonize -display none -monitor null=20

--gBBFr7Ir9EOA20Yy
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-ib1-08181713-f68f82364938548b58b51d4b926642b0a3cf4c27-filesystems_proc_show+-x-29154.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgZjY4ZjgyMy4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxl
cyBmb3IgMjAxNDA4MTgKZ2l0IGNoZWNrb3V0IDdkMTMxMWI5M2U1OGVkNTVmM2EzMWNjOGY5
NGM0YjhmZTk4OGEyYjkKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy9uZXh0Om1hc3Rlcjo3ZDEzMTFiOTNlNThlZDU1
ZjNhMzFjYzhmOTRjNGI4ZmU5ODhhMmI5OmJpc2VjdC1saW51eC00CgoyMDE0LTA4LTE5IDE0
OjQ2OjU2IDdkMTMxMWI5M2U1OGVkNTVmM2EzMWNjOGY5NGM0YjhmZTk4OGEyYjkgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLTdkMTMxMWI5M2U1OGVkNTVmM2EzMWNjOGY5
NGM0YjhmZTk4OGEyYjkKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWliMS0wODE4MTcxMy83ZDEzMTFiOTNlNThlZDU1ZjNhMzFjYzhmOTRjNGI4ZmU5
ODhhMmI5CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMtN2QxMzExYjkzZTU4ZWQ1NWYz
YTMxY2M4Zjk0YzRiOGZlOTg4YTJiOQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaWIxLTA4MTgxNzEzLzdkMTMxMWI5M2U1OGVkNTVmM2EzMWNjOGY5NGM0YjhmZTk4OGEy
Yjkvdm1saW51ei0zLjE3LjAtcmMxCgoyMDE0LTA4LTE5IDE0OjQ4OjU2IGRldGVjdGluZyBi
b290IHN0YXRlIAkyCTgJMTUJMjEJMzgJNDgJNTUgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNv
bW1pdCA3ZDEzMTFiOTNlNThlZDU1ZjNhMzFjYzhmOTRjNGI4ZmU5ODhhMmI5CmdpdCBiaXNl
Y3Qgc3RhcnQgZjY4ZjgyMzY0OTM4NTQ4YjU4YjUxZDRiOTI2NjQyYjBhM2NmNGMyNyA3ZDEz
MTFiOTNlNThlZDU1ZjNhMzFjYzhmOTRjNGI4ZmU5ODhhMmI5IC0tCi9jL2tlcm5lbC10ZXN0
cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgImY2OGY4MjM2NDkzODU0OGI1OGI1MWQ0YjkyNjY0
MmIwYTNjZjRjMjciLCAiLWciLCAiN2QxMzExYjkzZTU4ZWQ1NWYzYTMxY2M4Zjk0YzRiOGZl
OTg4YTJiOSIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IiwgIi9jL2Jvb3QtYmlzZWN0L2xpbnV4LTQvb2JqLWJpc2VjdCJdCkJpc2VjdGluZzogMTMy
NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTEgc3RlcHMp
Cls0NzNmOTYzOTgxOTY4NDc2NWU3OGQyOThmMTkyYjgwMzBmZTEyOTBjXSBNZXJnZSByZW1v
dGUtdHJhY2tpbmcgYnJhbmNoICdibG9jay9mb3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
LTQvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctaWIxLTA4MTgxNzEzL25leHQ6bWFzdGVyOjQ3M2Y5NjM5ODE5Njg0NzY1
ZTc4ZDI5OGYxOTJiODAzMGZlMTI5MGM6YmlzZWN0LWxpbnV4LTQKCjIwMTQtMDgtMTkgMTQ6
NTI6MjkgNDczZjk2Mzk4MTk2ODQ3NjVlNzhkMjk4ZjE5MmI4MDMwZmUxMjkwYyBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZf
NjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMtNDczZjk2Mzk4MTk2ODQ3NjVlNzhkMjk4ZjE5
MmI4MDMwZmUxMjkwYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaWIxLTA4MTgxNzEzLzQ3M2Y5NjM5ODE5Njg0NzY1ZTc4ZDI5OGYxOTJiODAzMGZl
MTI5MGMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy00NzNmOTYzOTgxOTY4NDc2NWU3
OGQyOThmMTkyYjgwMzBmZTEyOTBjCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1pYjEtMDgxODE3MTMvNDczZjk2Mzk4MTk2ODQ3NjVlNzhkMjk4ZjE5MmI4MDMwZmUxMjkw
Yy92bWxpbnV6LTMuMTcuMC1yYzEtMDA1NjItZzQ3M2Y5NjMKCjIwMTQtMDgtMTkgMTQ6NTQ6
MjkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTUyIFRFU1QgRkFJTFVSRQpbICAgIDguMDIzNzQ5
XSBob3N0bmFtZSAoNzYpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDE0MDAwIGJ5dGVz
IGxlZnQKWyAgICA4LjEwMTI3MF0gcGx5bW91dGhkICg3NykgdXNlZCBncmVhdGVzdCBzdGFj
ayBkZXB0aDogMTM0MDAgYnl0ZXMgbGVmdAptb3VudGFsbDogRXZlbnQgZmFpbGVkClsgICAg
OC4yNTg2MzVdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3Qg
YXQgZmZmZmZmZmYwNmE4MDAxOApbICAgIDguMjU5MDc0XSBJUDogWzxmZmZmZmZmZjgxMWFh
NTQ3Pl0gbW50X3NldF9tb3VudHBvaW50KzB4OGQvMHhiMQpbICAgIDguMjU5MDc0XSBQR0Qg
MWI2MzA2NyBQVUQgMCAKWyAgICA4LjI1OTA3NF0gT29wczogMDAwMiBbIzFdIERFQlVHX1BB
R0VBTExPQwpbICAgIDguMjU5MDc0XSBDUFU6IDAgUElEOiA5OCBDb21tOiBtb3VudCBOb3Qg
dGFpbnRlZCAzLjE3LjAtcmMxLTAwNTYyLWc0NzNmOTYzICMyClsgICAgOC4yNTkwNzRdIEhh
cmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICA4
LjI1OTA3NF0gdGFzazogZmZmZjg4MDAwYmI4ODAwMCB0aTogZmZmZjg4MDAwYmJiNDAwMCB0
YXNrLnRpOiBmZmZmODgwMDBiYmI0MDAwClsgICAgOC4yNTkwNzRdIFJJUDogMDAxMDpbPGZm
ZmZmZmZmODExYWE1NDc+XSAgWzxmZmZmZmZmZjgxMWFhNTQ3Pl0gbW50X3NldF9tb3VudHBv
aW50KzB4OGQvMHhiMQpbICAgIDguMjU5MDc0XSBSU1A6IDAwMTg6ZmZmZjg4MDAwYmJiN2Rm
MCAgRUZMQUdTOiAwMDAxMDI4MgpbICAgIDguMjU5MDc0XSBSQVg6IGZmZmZmZmZmMDZhODAw
MTAgUkJYOiBmZmZmODgwMDBiYmIzYmQ4IFJDWDogMDAwMDAwMDAwMDAwMDIyMgpbICAgIDgu
MjU5MDc0XSBSRFg6IGZmZmY4ODAwMGJiYmFlYjAgUlNJOiAwMDAwMDAwMDAwMDAwMDA0IFJE
STogZmZmZjg4MDAwYmJjNDZmMApbICAgIDguMjU5MDc0XSBSQlA6IGZmZmY4ODAwMGJiYjdl
MTAgUjA4OiAwMDAwMDAwMDAwMDAwMDA0IFIwOTogMDAwMWIzODkzODQ0MjIyMgpbICAgIDgu
MjU5MDc0XSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiBmZmZmZmZmZjgxZmIxZDQ4IFIx
MjogZmZmZjg4MDAwYmJiYWRjMApbICAgIDguMjU5MDc0XSBSMTM6IGZmZmY4ODAwMGNlMTFk
YzAgUjE0OiBmZmZmODgwMDBiYmM0NjcwIFIxNTogMDAwMDAwMDAwMDAwMDAyMApbICAgIDgu
MjU5MDc0XSBGUzogIDAwMDA3ZjBkOGEyNjc4MDAoMDAwMCkgR1M6ZmZmZmZmZmY4MWI3YzAw
MCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAgOC4yNTkwNzRdIENTOiAgMDAx
MCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwM2IKWyAgICA4LjI1OTA3
NF0gQ1IyOiBmZmZmZmZmZjA2YTgwMDE4IENSMzogMDAwMDAwMDAwYmJiMjAwMCBDUjQ6IDAw
MDAwMDAwMDAwMDA2YjAKWyAgICA4LjI1OTA3NF0gU3RhY2s6ClsgICAgOC4yNTkwNzRdICBm
ZmZmODgwMDBiYmJhZGMwIGZmZmY4ODAwMGNlMTFkYzAgZmZmZjg4MDAwYmJiM2JkOCAwMDAw
MDAwMDAwMDAwMDAwClsgICAgOC4yNTkwNzRdICBmZmZmODgwMDBiYmI3ZTU4IGZmZmZmZmZm
ODExYWJhMWQgZmZmZmZmZmY4MTFhYmJmMCAwMDAwMDAwMDAwMDAwMDAwClsgICAgOC4yNTkw
NzRdICBmZmZmODgwMDBiYmIzYmQ4IGZmZmY4ODAwMGJiYmFkYzAgZmZmZjg4MDAwYmJiM2Fm
OCBmZmZmODgwMDBiYmI3ZWQwClsgICAgOC4yNTkwNzRdIENhbGwgVHJhY2U6ClsgICAgOC4y
NTkwNzRdICBbPGZmZmZmZmZmODExYWJhMWQ+XSBhdHRhY2hfcmVjdXJzaXZlX21udCsweDFh
Zi8weDMyNgpbICAgIDguMjU5MDc0XSAgWzxmZmZmZmZmZjgxMWFiYmYwPl0gPyBncmFmdF90
cmVlKzB4NWMvMHg3MwpbICAgIDguMjU5MDc0XSAgWzxmZmZmZmZmZjgxMWFiYmYwPl0gZ3Jh
ZnRfdHJlZSsweDVjLzB4NzMKWyAgICA4LjI1OTA3NF0gIFs8ZmZmZmZmZmY4MTFhYmNmZT5d
IGRvX2FkZF9tb3VudCsweGY3LzB4MTFlClsgICAgOC4yNTkwNzRdICBbPGZmZmZmZmZmODEx
YWRlMTg+XSBkb19tb3VudCsweGYxOS8weGZlMgpbICAgIDguMjU5MDc0XSAgWzxmZmZmZmZm
ZjgxMTVhYzYwPl0gPyBtaWdodF9mYXVsdCsweDZmLzB4ZDEKWyAgICA4LjI1OTA3NF0gIFs8
ZmZmZmZmZmY4MTE0YjZiMj5dID8gc3RybmR1cF91c2VyKzB4NTEvMHg3MwpbICAgIDguMjU5
MDc0XSAgWzxmZmZmZmZmZjgxMWFlMjE2Pl0gU3lTX21vdW50KzB4YzgvMHgxMjQKWyAgICA4
LjI1OTA3NF0gIFs8ZmZmZmZmZmY4MTcyZGRkMT5dIHRyYWNlc3lzKzB4ZDMvMHhkOApbICAg
IDguMjU5MDc0XSBDb2RlOiBmMCAwMCAwMCAwMCA0ZCA4OSA2YyAyNCAxMCA0OSA4OSA5YyAy
NCBlOCAwMCAwMCAwMCA0OCA4YiA0MyAxOCA0OCA4NSBjMCA0OSA4OSA4NCAyNCBmMCAwMCAw
MCAwMCA3NSAwOSA0OCBmZiAwNSA1YiA1OCBiMyAwMSBlYiAwYiA8NDg+IDg5IDUwIDA4IDQ4
IGZmIDA1IDU2IDU4IGIzIDAxIDQ4IDg5IDUzIDE4IDQ4IDgzIGMzIDE4IDQ5IDg5IApbICAg
IDguMjU5MDc0XSBSSVAgIFs8ZmZmZmZmZmY4MTFhYTU0Nz5dIG1udF9zZXRfbW91bnRwb2lu
dCsweDhkLzB4YjEKWyAgICA4LjI1OTA3NF0gIFJTUCA8ZmZmZjg4MDAwYmJiN2RmMD4KWyAg
ICA4LjI1OTA3NF0gQ1IyOiBmZmZmZmZmZjA2YTgwMDE4ClsgICAgOC4yNTkwNzRdIC0tLVsg
ZW5kIHRyYWNlIGY3OTZkYTY5MWNkNWI4ZjIgXS0tLQpbICAgIDguMjU5MDc0XSBCVUc6IHNs
ZWVwaW5nIGZ1bmN0aW9uIGNhbGxlZCBmcm9tIGludmFsaWQgY29udGV4dCBhdCBrZXJuZWwv
bG9ja2luZy9yd3NlbS5jOjQxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgx
NzEzLzQ3M2Y5NjM5ODE5Njg0NzY1ZTc4ZDI5OGYxOTJiODAzMGZlMTI5MGMvZG1lc2ctcXVh
bnRhbC12cC0zMDoyMDE0MDgxOTE0NTMzMzp4ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3
MTM6My4xNy4wLXJjMS0wMDU2Mi1nNDczZjk2MzoyCjA6MTo1MyBhbGxfZ29vZDpiYWQ6YWxs
X2JhZCBib290cwobWzE7MzVtMjAxNC0wOC0xOSAxNDo1NTowMSBSRVBFQVQgQ09VTlQ6IDMw
MCAgIyAvYy9ib290LWJpc2VjdC9saW51eC00L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJp
c2VjdGluZzogNTYyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSAxMCBzdGVwcykKWzlhOWQyNGJiY2I3MTg1NzAwMjg2YjMwMGUxZGIxMzJhNDgxZDBlMWZd
IE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3RpbGUvbWFzdGVyJwpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNl
Y3QvbGludXgtNC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvbmV4dDptYXN0ZXI6OWE5ZDI0YmJj
YjcxODU3MDAyODZiMzAwZTFkYjEzMmE0ODFkMGUxZjpiaXNlY3QtbGludXgtNAoKMjAxNC0w
OC0xOSAxNDo1NTowNCA5YTlkMjRiYmNiNzE4NTcwMDI4NmIzMDBlMWRiMTMyYTQ4MWQwZTFm
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy05YTlkMjRiYmNiNzE4NTcwMDI4
NmIzMDBlMWRiMTMyYTQ4MWQwZTFmCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvOWE5ZDI0YmJjYjcxODU3MDAyODZiMzAwZTFk
YjEzMmE0ODFkMGUxZgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLTlhOWQyNGJiY2I3
MTg1NzAwMjg2YjMwMGUxZGIxMzJhNDgxZDBlMWYKa2VybmVsOiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWliMS0wODE4MTcxMy85YTlkMjRiYmNiNzE4NTcwMDI4NmIzMDBlMWRiMTMy
YTQ4MWQwZTFmL3ZtbGludXotMy4xNy4wLXJjMS0wMDMwNS1nOWE5ZDI0YgoKMjAxNC0wOC0x
OSAxNDo1NzowNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMzAJMzMJMzQJOTkJMTA0LgkxNzIJ
MTc3CTE4MwkyNTEJMjYxCTI5MwkzMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyNTcgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMpCltjMDY5OGI3
ZDk4NDdlMGNiYzQ2ODgxMzY4ZWM5YzcyNDc0OTY4YWQ4XSBNZXJnZSByZW1vdGUtdHJhY2tp
bmcgYnJhbmNoICdoaWQvZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC00L29iai1iaXNl
Y3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LWliMS0wODE4MTcxMy9uZXh0Om1hc3RlcjpjMDY5OGI3ZDk4NDdlMGNiYzQ2ODgxMzY4ZWM5
YzcyNDc0OTY4YWQ4OmJpc2VjdC1saW51eC00CgoyMDE0LTA4LTE5IDE1OjAzOjM4IGMwNjk4
YjdkOTg0N2UwY2JjNDY4ODEzNjhlYzljNzI0NzQ5NjhhZDggY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctaWIxLTA4MTgxNzEzLWMwNjk4YjdkOTg0N2UwY2JjNDY4ODEzNjhlYzljNzI0NzQ5Njhh
ZDgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0w
ODE4MTcxMy9jMDY5OGI3ZDk4NDdlMGNiYzQ2ODgxMzY4ZWM5YzcyNDc0OTY4YWQ4CndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1pYjEtMDgxODE3MTMtYzA2OThiN2Q5ODQ3ZTBjYmM0Njg4MTM2OGVjOWM3
MjQ3NDk2OGFkOAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgx
NzEzL2MwNjk4YjdkOTg0N2UwY2JjNDY4ODEzNjhlYzljNzI0NzQ5NjhhZDgvdm1saW51ei0z
LjE3LjAtcmMxLTAwMzc1LWdjMDY5OGI3CgoyMDE0LTA4LTE5IDE1OjA1OjM5IGRldGVjdGlu
ZyBib290IHN0YXRlIAkzNSBURVNUIEZBSUxVUkUKWyAgICA3Ljk3MjkzNV0gcGx5bW91dGhk
ICgxMzMpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDEzNzUyIGJ5dGVzIGxlZnQKWyAg
ICA4LjAyODU2Nl0gbW91bnRhbGwgKDE0MikgdXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDog
MTMwMzIgYnl0ZXMgbGVmdAptb3VudGFsbDogRXZlbnQgZmFpbGVkClsgICAgOC4yNTU1NDZd
IEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgZmZmZmZm
ZmZmZmZmZmZlOQpbICAgIDguMjU2MDE1XSBJUDogWzxmZmZmZmZmZjgxMTVjZTQ1Pl0gZmlu
ZF92bWFfbGlua3MrMHgxNy8weDdkClsgICAgOC4yNTYwMTVdIFBHRCAxYjYzMDY3IFBVRCAx
YjY1MDY3IFBNRCAwIApbICAgIDguMjU2MDE1XSBPb3BzOiAwMDAwIFsjMV0gREVCVUdfUEFH
RUFMTE9DClsgICAgOC4yNTYwMTVdIENQVTogMCBQSUQ6IDE1NSBDb21tOiBtb3VudCBOb3Qg
dGFpbnRlZCAzLjE3LjAtcmMxLTAwMzc1LWdjMDY5OGI3ICMxClsgICAgOC4yNTYwMTVdIEhh
cmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICA4
LjI1NjAxNV0gdGFzazogZmZmZjg4MDAwYmI5ZTAwMCB0aTogZmZmZjg4MDAwYmJiODAwMCB0
YXNrLnRpOiBmZmZmODgwMDBiYmI4MDAwClsgICAgOC4yNTYwMTVdIFJJUDogMDAxMDpbPGZm
ZmZmZmZmODExNWNlNDU+XSAgWzxmZmZmZmZmZjgxMTVjZTQ1Pl0gZmluZF92bWFfbGlua3Mr
MHgxNy8weDdkClsgICAgOC4yNTYwMTVdIFJTUDogMDAxODpmZmZmODgwMDBiYmJiZGU4ICBF
RkxBR1M6IDAwMDEwMjAyClsgICAgOC4yNTYwMTVdIFJBWDogMDAwMDAwMDAwMDAwMDAwMSBS
Qlg6IDAwMDAwMDAwMDAwMDAwNzMgUkNYOiBmZmZmODgwMDBiYmJiZTMwClsgICAgOC4yNTYw
MTVdIFJEWDogMDAwMDdmMTBiOWZjNjAwMCBSU0k6IDAwMDA3ZjEwYjlmYzUwMDAgUkRJOiBm
ZmZmODgwMDBiYWZlYWIwClsgICAgOC4yNTYwMTVdIFJCUDogZmZmZjg4MDAwYmJiYmRlOCBS
MDg6IGZmZmY4ODAwMGJiYmJlMzggUjA5OiBmZmZmODgwMDBiYmJiZTQwClsgICAgOC4yNTYw
MTVdIFIxMDogZmZmZjg4MDAwYmFmZWFhOCBSMTE6IGZmZmY4ODAwMGJhZmVhYTggUjEyOiAw
MDAwMDAwMDAwMDAwMDAwClsgICAgOC4yNTYwMTVdIFIxMzogZmZmZjg4MDAwYmJkNmE0MCBS
MTQ6IDAwMDA3ZjEwYjlmYzUwMDAgUjE1OiAwMDAwMDAwMDAwMDAxMDAwClsgICAgOC4yNTYw
MTVdIEZTOiAgMDAwMDdmMTBiOWZiZjgwMCgwMDAwKSBHUzpmZmZmZmZmZjgxYjdjMDAwKDAw
MDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICA4LjI1NjAxNV0gQ1M6ICAwMDEwIERT
OiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMwpbICAgIDguMjU2MDE1XSBD
UjI6IGZmZmZmZmZmZmZmZmZmZTkgQ1IzOiAwMDAwMDAwMDBiYmI3MDAwIENSNDogMDAwMDAw
MDAwMDA0MDZiMApbICAgIDguMjU2MDE1XSBTdGFjazoKWyAgICA4LjI1NjAxNV0gIGZmZmY4
ODAwMGJiYmJlNzAgZmZmZmZmZmY4MTE2MDgyYiAwMDAwMDAwMDAwMDAwMDAxIDAwMDAwMDAw
MDAwMDEwMDAKWyAgICA4LjI1NjAxNV0gIDAwMDAwMDAwMDAwMDEwMDAgMDAwMDAwMDdmMTBi
OWZjNSAwMDAwN2YxMGI5ZmM2MDAwIDAwMDAwMDAwMDAwMDAwMDEKWyAgICA4LjI1NjAxNV0g
IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMTAwMCAwMDAwMDAwMDAwMDAwMDAwIDAw
MDAwMDAwMDAwMDEwMDAKWyAgICA4LjI1NjAxNV0gQ2FsbCBUcmFjZToKWyAgICA4LjI1NjAx
NV0gIFs8ZmZmZmZmZmY4MTE2MDgyYj5dIG1tYXBfcmVnaW9uKzB4MTUxLzB4NjllClsgICAg
OC4yNTYwMTVdICBbPGZmZmZmZmZmODExNjExMzQ+XSBkb19tbWFwX3Bnb2ZmKzB4M2JjLzB4
NDNhClsgICAgOC4yNTYwMTVdICBbPGZmZmZmZmZmODExNGJiMmE+XSB2bV9tbWFwX3Bnb2Zm
KzB4NzIvMHhiYgpbICAgIDguMjU2MDE1XSAgWzxmZmZmZmZmZjgxMTVlYTRlPl0gU3lTX21t
YXBfcGdvZmYrMHg5Mi8weGUxClsgICAgOC4yNTYwMTVdICBbPGZmZmZmZmZmODEwMDkxMGE+
XSBTeVNfbW1hcCsweDI0LzB4MzcKWyAgICA4LjI1NjAxNV0gIFs8ZmZmZmZmZmY4MTcyZGQ5
MT5dIHRyYWNlc3lzKzB4ZDMvMHhkOApbICAgIDguMjU2MDE1XSBDb2RlOiAxYiA0OCBmZiAw
NSA2ZSA1MSBiNSAwMSA0OCA4MyBlMyBmYyA0OCA4NSBkYiA3NSBjYyA1YiA1ZCBjMyA1NSA0
OCA4MyBjNyAwOCA0NSAzMSBkMiA0NSAzMSBkYiA0OCA4OSBlNSBlYiAzMSA0OCBmZiAwNSAx
YiA1MiBiNSAwMSA8NDg+IDM5IDcwIGU4IDc2IDBjIDQ4IDM5IDUwIGUwIDcyIDUzIDQ4IDhk
IDc4IDEwIGViIDBlIDQ4IGZmIDA1IApbICAgIDguMjU2MDE1XSBSSVAgIFs8ZmZmZmZmZmY4
MTE1Y2U0NT5dIGZpbmRfdm1hX2xpbmtzKzB4MTcvMHg3ZApbICAgIDguMjU2MDE1XSAgUlNQ
IDxmZmZmODgwMDBiYmJiZGU4PgpbICAgIDguMjU2MDE1XSBDUjI6IGZmZmZmZmZmZmZmZmZm
ZTkKWyAgICA4LjI1NjAxNV0gLS0tWyBlbmQgdHJhY2UgODkwYmZjODg0NzFkOWY4NyBdLS0t
ClsgICAgOC4yNTYwMTVdIEJVRzogc2xlZXBpbmcgZnVuY3Rpb24gY2FsbGVkIGZyb20gaW52
YWxpZCBjb250ZXh0IGF0IGtlcm5lbC9sb2NraW5nL3J3c2VtLmM6NDEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvYzA2OThiN2Q5ODQ3ZTBjYmM0Njg4MTM2OGVj
OWM3MjQ3NDk2OGFkOC9kbWVzZy1xdWFudGFsLWtidWlsZC04OjIwMTQwODE5MTUwNDAyOng4
Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMzozLjE3LjAtcmMxLTAwMzc1LWdjMDY5OGI3
OjEKMDoxOjM2IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA4LTE5
IDE1OjA2OjEwIFJFUEVBVCBDT1VOVDogMzAwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTQv
b2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA3MCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykKW2Y1NTA1ODQ2M2E1N2E1OWU4
YjVhNTlmOGI0YWUxODc1YzdhOTFhNDRdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2gg
J2ZzY2FjaGUvZnNjYWNoZScKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTQvb2JqLWJpc2VjdApscyAt
YSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaWIxLTA4
MTgxNzEzL25leHQ6bWFzdGVyOmY1NTA1ODQ2M2E1N2E1OWU4YjVhNTlmOGI0YWUxODc1Yzdh
OTFhNDQ6YmlzZWN0LWxpbnV4LTQKCjIwMTQtMDgtMTkgMTU6MDY6MTIgZjU1MDU4NDYzYTU3
YTU5ZThiNWE1OWY4YjRhZTE4NzVjN2E5MWE0NCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRh
c2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pYjEt
MDgxODE3MTMtZjU1MDU4NDYzYTU3YTU5ZThiNWE1OWY4YjRhZTE4NzVjN2E5MWE0NApDaGVj
ayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEz
L2Y1NTA1ODQ2M2E1N2E1OWU4YjVhNTlmOGI0YWUxODc1YzdhOTFhNDQKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLWliMS0wODE4MTcxMy1mNTUwNTg0NjNhNTdhNTllOGI1YTU5ZjhiNGFlMTg3NWM3YTkx
YTQ0Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvZjU1
MDU4NDYzYTU3YTU5ZThiNWE1OWY4YjRhZTE4NzVjN2E5MWE0NC92bWxpbnV6LTMuMTcuMC1y
YzEtMDAzMjUtZ2Y1NTA1ODQKCjIwMTQtMDgtMTkgMTU6MDg6MTIgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLi4JMjgJNTcJMTE4CTE1NQkyMDcJMjIyCTI1OAkzMDAgU1VDQ0VTUwoKQmlzZWN0
aW5nOiA1MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBz
dGVwcykKWzc2YmIxMjQxYmVjNWY1OTdiMDI1Yjk5N2Q2YWU3ZTE5M2RhYjgyODldIE1lcmdl
IHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2xvZ2ZzL21hc3RlcicKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xp
bnV4LTQvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzL25leHQ6bWFzdGVyOjc2YmIxMjQxYmVjNWY1
OTdiMDI1Yjk5N2Q2YWU3ZTE5M2RhYjgyODk6YmlzZWN0LWxpbnV4LTQKCjIwMTQtMDgtMTkg
MTU6MTM6MjIgNzZiYjEyNDFiZWM1ZjU5N2IwMjViOTk3ZDZhZTdlMTkzZGFiODI4OSBjb21w
aWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94
ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMtNzZiYjEyNDFiZWM1ZjU5N2IwMjViOTk3
ZDZhZTdlMTkzZGFiODI4OQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaWIxLTA4MTgxNzEzLzc2YmIxMjQxYmVjNWY1OTdiMDI1Yjk5N2Q2YWU3ZTE5
M2RhYjgyODkKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy03NmJiMTI0MWJlYzVmNTk3
YjAyNWI5OTdkNmFlN2UxOTNkYWI4Mjg5Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1pYjEtMDgxODE3MTMvNzZiYjEyNDFiZWM1ZjU5N2IwMjViOTk3ZDZhZTdlMTkzZGFi
ODI4OS92bWxpbnV6LTMuMTcuMC1yYzEtMDAzMzEtZzc2YmIxMjQKCjIwMTQtMDgtMTkgMTU6
MTU6MjIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxNgkyMy4uLi4uLgkyNAkyNwkzMAkzOC4u
Li4uCTM5Lgk0OAk1Ngk1OQkxMTcJMTQzCTE2MgkxNzAJMTkxCTIxMgkyMzEJMjMzCTI2Nwky
OTAJMzAwIFNVQ0NFU1MKCkJpc2VjdGluZzogNDQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMpCls5MDE2Y2ViNGIzNjk5YmM5NWZmYWVlZDM3
MWU1ZmQwNzQ1YmFiMjI0XSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICd2ZnMvZm9y
LW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC00L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy9uZXh0
Om1hc3Rlcjo5MDE2Y2ViNGIzNjk5YmM5NWZmYWVlZDM3MWU1ZmQwNzQ1YmFiMjI0OmJpc2Vj
dC1saW51eC00CgoyMDE0LTA4LTE5IDE1OjMyOjQ3IDkwMTZjZWI0YjM2OTliYzk1ZmZhZWVk
MzcxZTVmZDA3NDViYWIyMjQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLTkw
MTZjZWI0YjM2OTliYzk1ZmZhZWVkMzcxZTVmZDA3NDViYWIyMjQKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy85MDE2Y2ViNGIz
Njk5YmM5NWZmYWVlZDM3MWU1ZmQwNzQ1YmFiMjI0CndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgx
ODE3MTMtOTAxNmNlYjRiMzY5OWJjOTVmZmFlZWQzNzFlNWZkMDc0NWJhYjIyNAprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLzkwMTZjZWI0YjM2OTli
Yzk1ZmZhZWVkMzcxZTVmZDA3NDViYWIyMjQvdm1saW51ei0zLjE3LjAtcmMxLTAwMzUzLWc5
MDE2Y2ViCgoyMDE0LTA4LTE5IDE1OjQ2OjQ3IGRldGVjdGluZyBib290IHN0YXRlIAkxMDUJ
MjIyCTI4NwkyOTQJMjk5Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkzMDAgU1VDQ0VTUwoK
QmlzZWN0aW5nOiAyMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgNSBzdGVwcykKWzJiZTcyOTQwOGUxMTc1ZDE3YWQxY2M5MGU5M2U5MDFjYzBiZTFiODFd
IE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3BjaS9uZXh0JwpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3Qv
bGludXgtNC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvbmV4dDptYXN0ZXI6MmJlNzI5NDA4ZTEx
NzVkMTdhZDFjYzkwZTkzZTkwMWNjMGJlMWI4MTpiaXNlY3QtbGludXgtNAoKMjAxNC0wOC0x
OSAxNjowMjoxOCAyYmU3Mjk0MDhlMTE3NWQxN2FkMWNjOTBlOTNlOTAxY2MwYmUxYjgxIGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy0yYmU3Mjk0MDhlMTE3NWQxN2FkMWNj
OTBlOTNlOTAxY2MwYmUxYjgxCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvMmJlNzI5NDA4ZTExNzVkMTdhZDFjYzkwZTkzZTkw
MWNjMGJlMWI4MQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLTJiZTcyOTQwOGUxMTc1
ZDE3YWQxY2M5MGU5M2U5MDFjYzBiZTFiODEKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWliMS0wODE4MTcxMy8yYmU3Mjk0MDhlMTE3NWQxN2FkMWNjOTBlOTNlOTAxY2Mw
YmUxYjgxL3ZtbGludXotMy4xNy4wLXJjMS0wMDM2Mi1nMmJlNzI5NAoKMjAxNC0wOC0xOSAx
NjowNDoxOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMjQgVEVTVCBGQUlMVVJFClsgICAgNC4z
NDQ2MzRdIGhvc3RuYW1lICgxMzEpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDE0MDAw
IGJ5dGVzIGxlZnQKWyAgICA0LjM4ODg2N10gaHdjbG9jayAoMTM0KSB1c2VkIGdyZWF0ZXN0
IHN0YWNrIGRlcHRoOiAxMzYwOCBieXRlcyBsZWZ0Cm1vdW50YWxsOiBFdmVudCBmYWlsZWQK
WyAgICA0LjUyOTAwOF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50
ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAwMDAwMDAwMDAwOQpbICAgIDQuNTI5MDEyXSBJUDog
WzxmZmZmZmZmZjgxMWFhNTQ3Pl0gbW50X3NldF9tb3VudHBvaW50KzB4OGQvMHhiMQpbICAg
IDQuNTI5MDEyXSBQR0QgYmI2NzA2NyBQVUQgYmFmYTA2NyBQTUQgMCAKWyAgICA0LjUyOTAx
Ml0gT29wczogMDAwMiBbIzFdIERFQlVHX1BBR0VBTExPQwpbICAgIDQuNTI5MDEyXSBDUFU6
IDAgUElEOiAxNTMgQ29tbTogbW91bnQgTm90IHRhaW50ZWQgMy4xNy4wLXJjMS0wMDM2Mi1n
MmJlNzI5NCAjMQpbICAgIDQuNTI5MDEyXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2Nocywg
QklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgNC41MjkwMTJdIHRhc2s6IGZmZmY4ODAwMGJi
ODIwMDAgdGk6IGZmZmY4ODAwMGJiMTAwMDAgdGFzay50aTogZmZmZjg4MDAwYmIxMDAwMApb
ICAgIDQuNTI5MDEyXSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxMWFhNTQ3Pl0gIFs8ZmZmZmZm
ZmY4MTFhYTU0Nz5dIG1udF9zZXRfbW91bnRwb2ludCsweDhkLzB4YjEKWyAgICA0LjUyOTAx
Ml0gUlNQOiAwMDE4OmZmZmY4ODAwMGJiMTNkZjAgIEVGTEFHUzogMDAwMTAyMDIKWyAgICA0
LjUyOTAxMl0gUkFYOiAwMDAwMDAwMDAwMDAwMDAxIFJCWDogZmZmZjg4MDAwYmI3ZWZhOCBS
Q1g6IDAwMDAwMDAwMDAwMDAyMjIKWyAgICA0LjUyOTAxMl0gUkRYOiBmZmZmODgwMDBkNmIy
NjMwIFJTSTogMDAwMDAwMDAwMDAwMDAwNCBSREk6IGZmZmY4ODAwMGJhYzJjMzAKWyAgICA0
LjUyOTAxMl0gUkJQOiBmZmZmODgwMDBiYjEzZTEwIFIwODogMDAwMDAwMDAwMDAwMDAwNCBS
MDk6IDAwMDFiMjg5MzQ0NDIyMjIKWyAgICA0LjUyOTAxMl0gUjEwOiAwMDAwMDAwMDAwMDAw
MDAwIFIxMTogZmZmZmZmZmY4MWZiMTYwOCBSMTI6IGZmZmY4ODAwMGQ2YjI1NDAKWyAgICA0
LjUyOTAxMl0gUjEzOiBmZmZmODgwMDBjZGMwYTQwIFIxNDogZmZmZjg4MDAwYmFjMmJiMCBS
MTU6IDAwMDAwMDAwMDAwMDAwMjAKWyAgICA0LjUyOTAxMl0gRlM6ICAwMDAwN2ZkZGViYmQz
ODAwKDAwMDApIEdTOmZmZmZmZmZmODFiN2MwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAw
MDAwMApbICAgIDQuNTI5MDEyXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAw
MDAwMDAwMDgwMDUwMDMzClsgICAgNC41MjkwMTJdIENSMjogMDAwMDAwMDAwMDAwMDAwOSBD
UjM6IDAwMDAwMDAwMGJiYTMwMDAgQ1I0OiAwMDAwMDAwMDAwMDQwNmIwClsgICAgNC41Mjkw
MTJdIFN0YWNrOgpbICAgIDQuNTI5MDEyXSAgZmZmZjg4MDAwZDZiMjU0MCBmZmZmODgwMDBj
ZGMwYTQwIGZmZmY4ODAwMGJiN2VmYTggMDAwMDAwMDAwMDAwMDAwMApbICAgIDQuNTI5MDEy
XSAgZmZmZjg4MDAwYmIxM2U1OCBmZmZmZmZmZjgxMWFiYTFkIGZmZmZmZmZmODExYWJiZjAg
MDAwMDAwMDAwMDAwMDAwMApbICAgIDQuNTI5MDEyXSAgZmZmZjg4MDAwYmI3ZWZhOCBmZmZm
ODgwMDBkNmIyNTQwIGZmZmY4ODAwMGJiN2UxYjggZmZmZjg4MDAwYmIxM2VkMApbICAgIDQu
NTI5MDEyXSBDYWxsIFRyYWNlOgpbICAgIDQuNTI5MDEyXSAgWzxmZmZmZmZmZjgxMWFiYTFk
Pl0gYXR0YWNoX3JlY3Vyc2l2ZV9tbnQrMHgxYWYvMHgzMjYKWyAgICA0LjUyOTAxMl0gIFs8
ZmZmZmZmZmY4MTFhYmJmMD5dID8gZ3JhZnRfdHJlZSsweDVjLzB4NzMKWyAgICA0LjUyOTAx
Ml0gIFs8ZmZmZmZmZmY4MTFhYmJmMD5dIGdyYWZ0X3RyZWUrMHg1Yy8weDczClsgICAgNC41
MjkwMTJdICBbPGZmZmZmZmZmODExYWJjZmU+XSBkb19hZGRfbW91bnQrMHhmNy8weDExZQpb
ICAgIDQuNTI5MDEyXSAgWzxmZmZmZmZmZjgxMWFkZTE4Pl0gZG9fbW91bnQrMHhmMTkvMHhm
ZTIKWyAgICA0LjUyOTAxMl0gIFs8ZmZmZmZmZmY4MTE1YWM2MD5dID8gbWlnaHRfZmF1bHQr
MHg2Zi8weGQxClsgICAgNC41MjkwMTJdICBbPGZmZmZmZmZmODExNGI2YjI+XSA/IHN0cm5k
dXBfdXNlcisweDUxLzB4NzMKWyAgICA0LjUyOTAxMl0gIFs8ZmZmZmZmZmY4MTFhZTIxNj5d
IFN5U19tb3VudCsweGM4LzB4MTI0ClsgICAgNC41MjkwMTJdICBbPGZmZmZmZmZmODE3MmRk
OTE+XSB0cmFjZXN5cysweGQzLzB4ZDgKWyAgICA0LjUyOTAxMl0gQ29kZTogZjAgMDAgMDAg
MDAgNGQgODkgNmMgMjQgMTAgNDkgODkgOWMgMjQgZTggMDAgMDAgMDAgNDggOGIgNDMgMTgg
NDggODUgYzAgNDkgODkgODQgMjQgZjAgMDAgMDAgMDAgNzUgMDkgNDggZmYgMDUgNWIgNTgg
YjMgMDEgZWIgMGIgPDQ4PiA4OSA1MCAwOCA0OCBmZiAwNSA1NiA1OCBiMyAwMSA0OCA4OSA1
MyAxOCA0OCA4MyBjMyAxOCA0OSA4OSAKWyAgICA0LjUyOTAxMl0gUklQICBbPGZmZmZmZmZm
ODExYWE1NDc+XSBtbnRfc2V0X21vdW50cG9pbnQrMHg4ZC8weGIxClsgICAgNC41MjkwMTJd
ICBSU1AgPGZmZmY4ODAwMGJiMTNkZjA+ClsgICAgNC41MjkwMTJdIENSMjogMDAwMDAwMDAw
MDAwMDAwOQpbICAgIDQuNTI5MDEyXSAtLS1bIGVuZCB0cmFjZSBjNjk3MDk3ZThkZThlYmE1
IF0tLS0KWyAgICA0LjUyOTAxMl0gQlVHOiBzbGVlcGluZyBmdW5jdGlvbiBjYWxsZWQgZnJv
bSBpbnZhbGlkIGNvbnRleHQgYXQga2VybmVsL2xvY2tpbmcvcndzZW0uYzo0MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy8yYmU3Mjk0MDhlMTE3NWQxN2FkMWNj
OTBlOTNlOTAxY2MwYmUxYjgxL2RtZXNnLXF1YW50YWwta2J1aWxkLTIzOjIwMTQwODE5MTYw
MjE1Ong4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMzozLjE3LjAtcmMxLTAwMzYyLWcy
YmU3Mjk0OjEKMDoxOjI1IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpsaW5lYXItYmlz
ZWN0OiBiYWQgYnJhbmNoIG1heSBiZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdwY2kvbmV4
dCcKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5lYXItYmlz
ZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IDJiZTcyOTQwOGUxMTc1ZDE3YWQxY2M5MGU5M2U5MDFj
YzBiZTFiODEgOTAxNmNlYjRiMzY5OWJjOTVmZmFlZWQzNzFlNWZkMDc0NWJhYjIyNCAtLQpQ
cmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAyYmU3Mjk0Li4uIE1lcmdlIHJlbW90ZS10cmFj
a2luZyBicmFuY2ggJ3BjaS9uZXh0JwpIRUFEIGlzIG5vdyBhdCAxNzFjMDYyLi4uIE1lcmdl
IHRhZyAnbW1jLXYzLjE2LTInIG9mIGdpdDovL2dpdC5saW5hcm8ub3JnL3Blb3BsZS91bGYu
aGFuc3Nvbi9tbWMKQmlzZWN0aW5nOiA0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbYTFjMGFlOWMyNDYyN2ExMmM3ODFlYmQ5OTQ3YTY0
NDI4NjFmNjE2OF0gUENJOiBkZXNpZ253YXJlOiBBZGQgY29uZmlnIGFjY2Vzcy1yZWxhdGVk
IHBjaWVfaG9zdF9vcHMgZm9yIHYzLjY1IGhhcmR3YXJlCmxpbmVhci1iaXNlY3Q6IGdpdCBi
aXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2MvYm9vdC1iaXNlY3QvbGludXgtNC9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC00
L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLWliMS0wODE4MTcxMy9uZXh0Om1hc3RlcjphMWMwYWU5YzI0NjI3YTEyYzc4
MWViZDk5NDdhNjQ0Mjg2MWY2MTY4OmJpc2VjdC1saW51eC00CgoyMDE0LTA4LTE5IDE2OjA0
OjU1IGExYzBhZTljMjQ2MjdhMTJjNzgxZWJkOTk0N2E2NDQyODYxZjYxNjggY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0
LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLWExYzBhZTljMjQ2MjdhMTJjNzgxZWJkOTk0N2E2
NDQyODYxZjYxNjgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWliMS0wODE4MTcxMy9hMWMwYWU5YzI0NjI3YTEyYzc4MWViZDk5NDdhNjQ0Mjg2MWY2
MTY4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMtYTFjMGFlOWMyNDYyN2ExMmM3ODFl
YmQ5OTQ3YTY0NDI4NjFmNjE2OAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aWIxLTA4MTgxNzEzL2ExYzBhZTljMjQ2MjdhMTJjNzgxZWJkOTk0N2E2NDQyODYxZjYxNjgv
dm1saW51ei0zLjE2LjAtcmMxLTAwMDA0LWdhMWMwYWU5CgoyMDE0LTA4LTE5IDE2OjA4OjU1
IGRldGVjdGluZyBib290IHN0YXRlIAk4CTIwCTI4CTM2CTUzCTcwCTg5CTEwNgkxMjMJMTUx
CTE4MwkyMTgJMjIyLi4uLi4uLgkyMjMJMjI0Li4uLi4uCTIyNS4JMjI2CTIyOAkyMzMJMjQw
CTI1MAkyNzAJMjc3CTI5NAkzMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzIHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCltjMjc2MDIwODZkMDhk
MjJiMDY3YTEyNjdlMDlmYjMyYjRiMDk2YWEwXSBQQ0k6IG12ZWJ1OiBSZW1vdmUgQVJDSF9L
SVJLV09PRCBkZXBlbmRlbmN5CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC00L29iai1iaXNlY3QKbHMg
LWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWliMS0w
ODE4MTcxMy9uZXh0Om1hc3RlcjpjMjc2MDIwODZkMDhkMjJiMDY3YTEyNjdlMDlmYjMyYjRi
MDk2YWEwOmJpc2VjdC1saW51eC00CgoyMDE0LTA4LTE5IDE2OjI4OjI2IGMyNzYwMjA4NmQw
OGQyMmIwNjdhMTI2N2UwOWZiMzJiNGIwOTZhYTAgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaWIx
LTA4MTgxNzEzLWMyNzYwMjA4NmQwOGQyMmIwNjdhMTI2N2UwOWZiMzJiNGIwOTZhYTAKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcx
My9jMjc2MDIwODZkMDhkMjJiMDY3YTEyNjdlMDlmYjMyYjRiMDk2YWEwCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1pYjEtMDgxODE3MTMtYzI3NjAyMDg2ZDA4ZDIyYjA2N2ExMjY3ZTA5ZmIzMmI0YjA5
NmFhMAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzL2My
NzYwMjA4NmQwOGQyMmIwNjdhMTI2N2UwOWZiMzJiNGIwOTZhYTAvdm1saW51ei0zLjE2LjAt
cmMxLTAwMDAyLWdjMjc2MDIwCgoyMDE0LTA4LTE5IDE2OjMwOjI2IGRldGVjdGluZyBib290
IHN0YXRlIC4uCTEuLi4JOAkxNAkyMwkyOAkzNwk0OQk1MS4uLgk1Mgk1NS4uCTU2Lgk1OQk3
MAk3NQk4OAkxMDUJMTE0CTEyMgkxMzUJMTQyLi4uLi4uLi4uLi4uLi4uLgkxNDMJMTQ0CTE0
NgkxNTEJMTU3CTE2MwkxNzIJMTc5CTE5NQkyMTAJMjI4CTI1MQkyNjYuCTI4NQkzMDAgU1VD
Q0VTUwoKQmlzZWN0aW5nOiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSAxIHN0ZXApClsyY2I5ODlmNmU5OWFhODQ5OTc5NjFmY2VmNTE2ZTVjZDEyM2I5
YTc4XSBQQ0k6IHRlZ3JhOiBBZGQgZGVidWdmcyBzdXBwb3J0CnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51
eC00L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy9uZXh0Om1hc3RlcjoyY2I5ODlmNmU5OWFhODQ5
OTc5NjFmY2VmNTE2ZTVjZDEyM2I5YTc4OmJpc2VjdC1saW51eC00CgoyMDE0LTA4LTE5IDE3
OjAxOjU3IDJjYjk4OWY2ZTk5YWE4NDk5Nzk2MWZjZWY1MTZlNWNkMTIzYjlhNzggY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLTJjYjk4OWY2ZTk5YWE4NDk5Nzk2MWZjZWY1
MTZlNWNkMTIzYjlhNzgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWliMS0wODE4MTcxMy8yY2I5ODlmNmU5OWFhODQ5OTc5NjFmY2VmNTE2ZTVjZDEy
M2I5YTc4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMtMmNiOTg5ZjZlOTlhYTg0OTk3
OTYxZmNlZjUxNmU1Y2QxMjNiOWE3OAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaWIxLTA4MTgxNzEzLzJjYjk4OWY2ZTk5YWE4NDk5Nzk2MWZjZWY1MTZlNWNkMTIzYjlh
Nzgvdm1saW51ei0zLjE2LjAtcmMxLTAwMDAyLWcyY2I5ODlmCgoyMDE0LTA4LTE5IDE3OjAz
OjU3IGRldGVjdGluZyBib290IHN0YXRlIC4uCTE1CTM5CTYwCTg2CTExNQkxNjEJMTk4CTI4
NAkzMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCls5ODFjMTkxNzc4YTRmOTJiYzgyNDU2MjA1YTQ0
NGQ1MjI4NDNhNjMwXSBNZXJnZSBicmFuY2hlcyAncGNpL2hvc3QtZGVzaWdud2FyZScsICdw
Y2kvaG9zdC1tdmVidScgYW5kICdwY2kvaG9zdC10ZWdyYScgaW50byBuZXh0CnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJp
c2VjdC9saW51eC00L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy9uZXh0Om1hc3Rlcjo5ODFjMTkx
Nzc4YTRmOTJiYzgyNDU2MjA1YTQ0NGQ1MjI4NDNhNjMwOmJpc2VjdC1saW51eC00CgoyMDE0
LTA4LTE5IDE3OjA5OjI4IDk4MWMxOTE3NzhhNGY5MmJjODI0NTYyMDVhNDQ0ZDUyMjg0M2E2
MzAgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLTk4MWMxOTE3NzhhNGY5MmJj
ODI0NTYyMDVhNDQ0ZDUyMjg0M2E2MzAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy85ODFjMTkxNzc4YTRmOTJiYzgyNDU2MjA1
YTQ0NGQ1MjI4NDNhNjMwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMtOTgxYzE5MTc3
OGE0ZjkyYmM4MjQ1NjIwNWE0NDRkNTIyODQzYTYzMAprZXJuZWw6IC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLzk4MWMxOTE3NzhhNGY5MmJjODI0NTYyMDVhNDQ0
ZDUyMjg0M2E2MzAvdm1saW51ei0zLjE2LjAtcmMxLTAwMDQ4LWc5ODFjMTkxCgoyMDE0LTA4
LTE5IDE3OjEyOjI4IGRldGVjdGluZyBib290IHN0YXRlIC4uCTQyCTExNwkxNjAJMjA5CTI5
OAkzMDAgU1VDQ0VTUwoKMmJlNzI5NDA4ZTExNzVkMTdhZDFjYzkwZTkzZTkwMWNjMGJlMWI4
MSBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApiaXNlY3QgcnVuIHN1Y2Nlc3MKUHJldmlvdXMg
SEVBRCBwb3NpdGlvbiB3YXMgOTgxYzE5MS4uLiBNZXJnZSBicmFuY2hlcyAncGNpL2hvc3Qt
ZGVzaWdud2FyZScsICdwY2kvaG9zdC1tdmVidScgYW5kICdwY2kvaG9zdC10ZWdyYScgaW50
byBuZXh0CkhFQUQgaXMgbm93IGF0IDkwMTZjZWIuLi4gTWVyZ2UgcmVtb3RlLXRyYWNraW5n
IGJyYW5jaCAndmZzL2Zvci1uZXh0JwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzL25leHQ6bWFzdGVyOjkwMTZjZWI0
YjM2OTliYzk1ZmZhZWVkMzcxZTVmZDA3NDViYWIyMjQ6YmlzZWN0LWxpbnV4LTQKCjIwMTQt
MDgtMTkgMTc6MTc6NDkgOTAxNmNlYjRiMzY5OWJjOTVmZmFlZWQzNzFlNWZkMDc0NWJhYjIy
NCByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy85MDE2Y2Vi
NGIzNjk5YmM5NWZmYWVlZDM3MWU1ZmQwNzQ1YmFiMjI0L3ZtbGludXotMy4xNy4wLXJjMS0w
MDM1My1nOTAxNmNlYgoKMjAxNC0wOC0xOSAxNzoxNzo0OSBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAJNwk1NAk3NAkxMDIgVEVTVCBGQUlMVVJFClsgICAgMC4wMDAwMDBdIEFDUEk6IEVhcmx5
IHRhYmxlIGNoZWNrc3VtIHZlcmlmaWNhdGlvbiBkaXNhYmxlZApbICAgIDAuMDAwMDAwXSBB
Q1BJOiBSU0RQIDB4MDAwMDAwMDAwMDBGMEM5MCAwMDAwMTQgKHYwMCBCT0NIUyApClsgICAg
MC4wMDAwMDBdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAu
MDAwMDAwXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAwIGF0IG1tL2Vhcmx5X2lvcmVtYXAuYzox
MzYgX19lYXJseV9pb3JlbWFwKzB4MTQyLzB4MmE5KCkKWyAgICAwLjAwMDAwMF0gQ1BVOiAw
IFBJRDogMCBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTcuMC1yYzEtMDAzNTMtZzkw
MTZjZWIgIzEKWyAgICAwLjAwMDAwMF0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQ
QyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgMS43LjUtMjAxNDA1MzFfMDgzMDMwLWdh
bmRhbGYgMDQvMDEvMjAxNApbICAgIDAuMDAwMDAwXSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZm
ZmZmZjgxYjRmZDMwIGZmZmZmZmZmODE3MTUzM2QgZmZmZmZmZmY4MWI0ZmQ2OApbICAgIDAu
MDAwMDAwXSAgZmZmZmZmZmY4MTA4Y2RkOSBmZmZmZmZmZjgxZTcxMTFjIDAwMDAwMDAwMDAw
MDAwMDAgMDAwMDAwMDAwMDBiYjU4OQpbICAgIDAuMDAwMDAwXSAgMDAwMDAwMDAwMDAwMDAw
MCAwMDAwMDAwMDAwMDAwMDAwIGZmZmZmZmZmODFiNGZkNzggZmZmZmZmZmY4MTA4Y2YxNApb
ICAgIDAuMDAwMDAwXSBDYWxsIFRyYWNlOgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgx
NzE1MzNkPl0gZHVtcF9zdGFjaysweDJlLzB4M2UKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZm
ZmY4MTA4Y2RkOT5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4OGMvMHhiYQpbICAgIDAuMDAw
MDAwXSAgWzxmZmZmZmZmZjgxZTcxMTFjPl0gPyBfX2Vhcmx5X2lvcmVtYXArMHgxNDIvMHgy
YTkKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTA4Y2YxND5dIHdhcm5fc2xvd3BhdGhf
bnVsbCsweDIzLzB4MmMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU3MTExYz5dIF9f
ZWFybHlfaW9yZW1hcCsweDE0Mi8weDJhOQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgx
NzJjYjcxPl0gPyBfcmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUrMHg1ZS8weDllClsgICAg
MC4wMDAwMDBdICBbPGZmZmZmZmZmODFlNzE1OWQ+XSBlYXJseV9pb3JlbWFwKzB4MWEvMHgy
MwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTVjNzcxPl0gX19hY3BpX21hcF90YWJs
ZSsweDIxLzB4MmYKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTcwYjE1MD5dIGFjcGlf
b3NfbWFwX2lvbWVtKzB4MjgvMHgyMDIKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTcw
YjMzYT5dIGFjcGlfb3NfbWFwX21lbW9yeSsweDEwLzB4MTkKWyAgICAwLjAwMDAwMF0gIFs8
ZmZmZmZmZmY4MWU3YmEwNT5dIGFjcGlfdGJfcGFyc2Vfcm9vdF90YWJsZSsweDE0Zi8weDI3
ZQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTdiYmMyPl0gYWNwaV9pbml0aWFsaXpl
X3RhYmxlcysweDhlLzB4OWIKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU3OTZhMj5d
IGFjcGlfdGFibGVfaW5pdCsweDZjLzB4MTM2ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZm
ODFlNWM4OTc+XSBhY3BpX2Jvb3RfdGFibGVfaW5pdCsweDM3LzB4ZjkKWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MWU1MWZkOD5dIHNldHVwX2FyY2grMHhjYjkvMHgxMTQ2ClsgICAg
MC4wMDAwMDBdICBbPGZmZmZmZmZmODFlNGRmOTE+XSBzdGFydF9rZXJuZWwrMHhlOC8weDY4
YgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTRkMTIwPl0gPyBlYXJseV9pZHRfaGFu
ZGxlcnMrMHgxMjAvMHgxMjAKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU0ZDU5Yz5d
IHg4Nl82NF9zdGFydF9yZXNlcnZhdGlvbnMrMHg0Ni8weDRmClsgICAgMC4wMDAwMDBdICBb
PGZmZmZmZmZmODFlNGQ2ZjM+XSB4ODZfNjRfc3RhcnRfa2VybmVsKzB4MTRlLzB4MTYyClsg
ICAgMC4wMDAwMDBdIC0tLVsgZW5kIHRyYWNlIDUxZDM5MWNiMDRhYjVlOTcgXS0tLQpbICAg
IDAuMDAwMDAwXSBrdm0tY2xvY2s6IFVzaW5nIG1zcnMgNGI1NjRkMDEgYW5kIDRiNTY0ZDAw
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLzkwMTZjZWI0YjM2OTli
Yzk1ZmZhZWVkMzcxZTVmZDA3NDViYWIyMjQvZG1lc2ctcXVhbnRhbC12cC0xMDoyMDE0MDgx
OTE3MTkxNDp4ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTM6My4xNy4wLXJjMS0wMDM1
My1nOTAxNmNlYjoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLzkw
MTZjZWI0YjM2OTliYzk1ZmZhZWVkMzcxZTVmZDA3NDViYWIyMjQvZG1lc2ctcXVhbnRhbC1p
dmI0NC0yMToyMDE0MDgxOTE3MTkyNTp4ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTM6
OgowOjI6NDA0IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgobWzE7MzVtMjAxNC0wOC0x
OSAxNzoxOTo1MCBiYWQgYmlzZWN0LCByZXRyeSB3aXRoIGluY3JlYXNlZCByZXBlYXQgY291
bnQgOTAwG1swbQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA5MDE2Y2ViLi4uIE1lcmdl
IHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3Zmcy9mb3ItbmV4dCcKSEVBRCBpcyBub3cgYXQg
ZjY4ZjgyMy4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA4MTgK
Z2l0IGNoZWNrb3V0IDdkMTMxMWI5M2U1OGVkNTVmM2EzMWNjOGY5NGM0YjhmZTk4OGEyYjkK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWli
MS0wODE4MTcxMy9uZXh0Om1hc3Rlcjo3ZDEzMTFiOTNlNThlZDU1ZjNhMzFjYzhmOTRjNGI4
ZmU5ODhhMmI5OmJpc2VjdC1saW51eC00CgoyMDE0LTA4LTE5IDE3OjE5OjU0IDdkMTMxMWI5
M2U1OGVkNTVmM2EzMWNjOGY5NGM0YjhmZTk4OGEyYjkgcmV1c2UgL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvN2QxMzExYjkzZTU4ZWQ1NWYzYTMxY2M4Zjk0YzRi
OGZlOTg4YTJiOS92bWxpbnV6LTMuMTcuMC1yYzEKCjIwMTQtMDgtMTkgMTc6MTk6NTQgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTc0CTkwCTEwNgkxMTcJMTMxCTE0NwkxOTEJMjM2CTM0
Nwk0NDQuLi4uLi4uLi4uLi4uLi4JNDU3Li4uLi4uLi4JNDYxCTQ2OAk0NzgJNDg5CTUwMgk1
MjAJNTQ5CTU4Ngk2MjgJNjc1CTcyMwk3NTkJODYwCTkwMCBTVUNDRVNTCgpiaXNlY3Q6IGdv
b2QgY29tbWl0IDdkMTMxMWI5M2U1OGVkNTVmM2EzMWNjOGY5NGM0YjhmZTk4OGEyYjkKZ2l0
IGJpc2VjdCBzdGFydCBmNjhmODIzNjQ5Mzg1NDhiNThiNTFkNGI5MjY2NDJiMGEzY2Y0YzI3
IDdkMTMxMWI5M2U1OGVkNTVmM2EzMWNjOGY5NGM0YjhmZTk4OGEyYjkgLS0KL2Mva2VybmVs
LXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiZjY4ZjgyMzY0OTM4NTQ4YjU4YjUxZDRi
OTI2NjQyYjBhM2NmNGMyNyIsICItZyIsICI3ZDEzMTFiOTNlNThlZDU1ZjNhMzFjYzhmOTRj
NGI4ZmU5ODhhMmI5IiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2giLCAiL2MvYm9vdC1iaXNlY3QvbGludXgtNC9vYmotYmlzZWN0Il0KQmlzZWN0aW5n
OiAxMzI1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBz
dGVwcykKWzQ3M2Y5NjM5ODE5Njg0NzY1ZTc4ZDI5OGYxOTJiODAzMGZlMTI5MGNdIE1lcmdl
IHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2Jsb2NrL2Zvci1uZXh0JwpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3Qv
bGludXgtNC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvbmV4dDptYXN0ZXI6NDczZjk2Mzk4MTk2
ODQ3NjVlNzhkMjk4ZjE5MmI4MDMwZmUxMjkwYzpiaXNlY3QtbGludXgtNAogVEVTVCBGQUlM
VVJFClsgICAgOC4wMjM3NDldIGhvc3RuYW1lICg3NikgdXNlZCBncmVhdGVzdCBzdGFjayBk
ZXB0aDogMTQwMDAgYnl0ZXMgbGVmdApbICAgIDguMTAxMjcwXSBwbHltb3V0aGQgKDc3KSB1
c2VkIGdyZWF0ZXN0IHN0YWNrIGRlcHRoOiAxMzQwMCBieXRlcyBsZWZ0Cm1vdW50YWxsOiBF
dmVudCBmYWlsZWQKWyAgICA4LjI1ODYzNV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5l
bCBwYWdpbmcgcmVxdWVzdCBhdCBmZmZmZmZmZjA2YTgwMDE4ClsgICAgOC4yNTkwNzRdIElQ
OiBbPGZmZmZmZmZmODExYWE1NDc+XSBtbnRfc2V0X21vdW50cG9pbnQrMHg4ZC8weGIxClsg
ICAgOC4yNTkwNzRdIFBHRCAxYjYzMDY3IFBVRCAwIApbICAgIDguMjU5MDc0XSBPb3BzOiAw
MDAyIFsjMV0gREVCVUdfUEFHRUFMTE9DClsgICAgOC4yNTkwNzRdIENQVTogMCBQSUQ6IDk4
IENvbW06IG1vdW50IE5vdCB0YWludGVkIDMuMTcuMC1yYzEtMDA1NjItZzQ3M2Y5NjMgIzIK
WyAgICA4LjI1OTA3NF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMg
MDEvMDEvMjAxMQpbICAgIDguMjU5MDc0XSB0YXNrOiBmZmZmODgwMDBiYjg4MDAwIHRpOiBm
ZmZmODgwMDBiYmI0MDAwIHRhc2sudGk6IGZmZmY4ODAwMGJiYjQwMDAKWyAgICA4LjI1OTA3
NF0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTFhYTU0Nz5dICBbPGZmZmZmZmZmODExYWE1NDc+
XSBtbnRfc2V0X21vdW50cG9pbnQrMHg4ZC8weGIxClsgICAgOC4yNTkwNzRdIFJTUDogMDAx
ODpmZmZmODgwMDBiYmI3ZGYwICBFRkxBR1M6IDAwMDEwMjgyClsgICAgOC4yNTkwNzRdIFJB
WDogZmZmZmZmZmYwNmE4MDAxMCBSQlg6IGZmZmY4ODAwMGJiYjNiZDggUkNYOiAwMDAwMDAw
MDAwMDAwMjIyClsgICAgOC4yNTkwNzRdIFJEWDogZmZmZjg4MDAwYmJiYWViMCBSU0k6IDAw
MDAwMDAwMDAwMDAwMDQgUkRJOiBmZmZmODgwMDBiYmM0NmYwClsgICAgOC4yNTkwNzRdIFJC
UDogZmZmZjg4MDAwYmJiN2UxMCBSMDg6IDAwMDAwMDAwMDAwMDAwMDQgUjA5OiAwMDAxYjM4
OTM4NDQyMjIyClsgICAgOC4yNTkwNzRdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IGZm
ZmZmZmZmODFmYjFkNDggUjEyOiBmZmZmODgwMDBiYmJhZGMwClsgICAgOC4yNTkwNzRdIFIx
MzogZmZmZjg4MDAwY2UxMWRjMCBSMTQ6IGZmZmY4ODAwMGJiYzQ2NzAgUjE1OiAwMDAwMDAw
MDAwMDAwMDIwClsgICAgOC4yNTkwNzRdIEZTOiAgMDAwMDdmMGQ4YTI2NzgwMCgwMDAwKSBH
UzpmZmZmZmZmZjgxYjdjMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICA4
LjI1OTA3NF0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1
MDAzYgpbICAgIDguMjU5MDc0XSBDUjI6IGZmZmZmZmZmMDZhODAwMTggQ1IzOiAwMDAwMDAw
MDBiYmIyMDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAgIDguMjU5MDc0XSBTdGFjazoK
WyAgICA4LjI1OTA3NF0gIGZmZmY4ODAwMGJiYmFkYzAgZmZmZjg4MDAwY2UxMWRjMCBmZmZm
ODgwMDBiYmIzYmQ4IDAwMDAwMDAwMDAwMDAwMDAKWyAgICA4LjI1OTA3NF0gIGZmZmY4ODAw
MGJiYjdlNTggZmZmZmZmZmY4MTFhYmExZCBmZmZmZmZmZjgxMWFiYmYwIDAwMDAwMDAwMDAw
MDAwMDAKWyAgICA4LjI1OTA3NF0gIGZmZmY4ODAwMGJiYjNiZDggZmZmZjg4MDAwYmJiYWRj
MCBmZmZmODgwMDBiYmIzYWY4IGZmZmY4ODAwMGJiYjdlZDAKWyAgICA4LjI1OTA3NF0gQ2Fs
bCBUcmFjZToKWyAgICA4LjI1OTA3NF0gIFs8ZmZmZmZmZmY4MTFhYmExZD5dIGF0dGFjaF9y
ZWN1cnNpdmVfbW50KzB4MWFmLzB4MzI2ClsgICAgOC4yNTkwNzRdICBbPGZmZmZmZmZmODEx
YWJiZjA+XSA/IGdyYWZ0X3RyZWUrMHg1Yy8weDczClsgICAgOC4yNTkwNzRdICBbPGZmZmZm
ZmZmODExYWJiZjA+XSBncmFmdF90cmVlKzB4NWMvMHg3MwpbICAgIDguMjU5MDc0XSAgWzxm
ZmZmZmZmZjgxMWFiY2ZlPl0gZG9fYWRkX21vdW50KzB4ZjcvMHgxMWUKWyAgICA4LjI1OTA3
NF0gIFs8ZmZmZmZmZmY4MTFhZGUxOD5dIGRvX21vdW50KzB4ZjE5LzB4ZmUyClsgICAgOC4y
NTkwNzRdICBbPGZmZmZmZmZmODExNWFjNjA+XSA/IG1pZ2h0X2ZhdWx0KzB4NmYvMHhkMQpb
ICAgIDguMjU5MDc0XSAgWzxmZmZmZmZmZjgxMTRiNmIyPl0gPyBzdHJuZHVwX3VzZXIrMHg1
MS8weDczClsgICAgOC4yNTkwNzRdICBbPGZmZmZmZmZmODExYWUyMTY+XSBTeVNfbW91bnQr
MHhjOC8weDEyNApbICAgIDguMjU5MDc0XSAgWzxmZmZmZmZmZjgxNzJkZGQxPl0gdHJhY2Vz
eXMrMHhkMy8weGQ4ClsgICAgOC4yNTkwNzRdIENvZGU6IGYwIDAwIDAwIDAwIDRkIDg5IDZj
IDI0IDEwIDQ5IDg5IDljIDI0IGU4IDAwIDAwIDAwIDQ4IDhiIDQzIDE4IDQ4IDg1IGMwIDQ5
IDg5IDg0IDI0IGYwIDAwIDAwIDAwIDc1IDA5IDQ4IGZmIDA1IDViIDU4IGIzIDAxIGViIDBi
IDw0OD4gODkgNTAgMDggNDggZmYgMDUgNTYgNTggYjMgMDEgNDggODkgNTMgMTggNDggODMg
YzMgMTggNDkgODkgClsgICAgOC4yNTkwNzRdIFJJUCAgWzxmZmZmZmZmZjgxMWFhNTQ3Pl0g
bW50X3NldF9tb3VudHBvaW50KzB4OGQvMHhiMQpbICAgIDguMjU5MDc0XSAgUlNQIDxmZmZm
ODgwMDBiYmI3ZGYwPgpbICAgIDguMjU5MDc0XSBDUjI6IGZmZmZmZmZmMDZhODAwMTgKWyAg
ICA4LjI1OTA3NF0gLS0tWyBlbmQgdHJhY2UgZjc5NmRhNjkxY2Q1YjhmMiBdLS0tClsgICAg
OC4yNTkwNzRdIEJVRzogc2xlZXBpbmcgZnVuY3Rpb24gY2FsbGVkIGZyb20gaW52YWxpZCBj
b250ZXh0IGF0IGtlcm5lbC9sb2NraW5nL3J3c2VtLmM6NDEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1pYjEtMDgxODE3MTMvNDczZjk2Mzk4MTk2ODQ3NjVlNzhkMjk4ZjE5MmI4MDMw
ZmUxMjkwYy9kbWVzZy1xdWFudGFsLXZwLTMwOjIwMTQwODE5MTQ1MzMzOng4Nl82NC1yYW5k
Y29uZmlnLWliMS0wODE4MTcxMzozLjE3LjAtcmMxLTAwNTYyLWc0NzNmOTYzOjIKMDoxOjU1
IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDU2MiByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpCls5YTlkMjRiYmNi
NzE4NTcwMDI4NmIzMDBlMWRiMTMyYTQ4MWQwZTFmXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcg
YnJhbmNoICd0aWxlL21hc3RlcicKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTQvb2JqLWJpc2VjdAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaWIx
LTA4MTgxNzEzL25leHQ6bWFzdGVyOjlhOWQyNGJiY2I3MTg1NzAwMjg2YjMwMGUxZGIxMzJh
NDgxZDBlMWY6YmlzZWN0LWxpbnV4LTQKCjIwMTQtMDgtMTkgMTc6NDU6MzMgOWE5ZDI0YmJj
YjcxODU3MDAyODZiMzAwZTFkYjEzMmE0ODFkMGUxZiByZXVzZSAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWliMS0wODE4MTcxMy85YTlkMjRiYmNiNzE4NTcwMDI4NmIzMDBlMWRiMTMy
YTQ4MWQwZTFmL3ZtbGludXotMy4xNy4wLXJjMS0wMDMwNS1nOWE5ZDI0YgoKMjAxNC0wOC0x
OSAxNzo0NTozMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMzIxCTQ0NC4uCTQ0Ngk0NDkJ
NDUyCTQ1NS4JNDYxCTQ4Mwk0OTEJNTQ1CTU3Nwk1ODMJNjExCTYyNQk2MjYuLgk2MzAJNjMx
CTYzNAk2NDUJNjUzCTY2OQk2ODAJNjg3CTcwMAk3MTQJNzM1CTc1OQk3ODEJODAzCTgzMwk4
NTcJODc5CTkwMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDI1NyByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKW2MwNjk4YjdkOTg0N2UwY2JjNDY4
ODEzNjhlYzljNzI0NzQ5NjhhZDhdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2hp
ZC9mb3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTQvb2JqLWJpc2VjdApscyAtYSAva2J1
aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEz
L25leHQ6bWFzdGVyOmMwNjk4YjdkOTg0N2UwY2JjNDY4ODEzNjhlYzljNzI0NzQ5NjhhZDg6
YmlzZWN0LWxpbnV4LTQKIFRFU1QgRkFJTFVSRQpbICAgIDcuOTcyOTM1XSBwbHltb3V0aGQg
KDEzMykgdXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDogMTM3NTIgYnl0ZXMgbGVmdApbICAg
IDguMDI4NTY2XSBtb3VudGFsbCAoMTQyKSB1c2VkIGdyZWF0ZXN0IHN0YWNrIGRlcHRoOiAx
MzAzMiBieXRlcyBsZWZ0Cm1vdW50YWxsOiBFdmVudCBmYWlsZWQKWyAgICA4LjI1NTU0Nl0g
QlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCBmZmZmZmZm
ZmZmZmZmZmU5ClsgICAgOC4yNTYwMTVdIElQOiBbPGZmZmZmZmZmODExNWNlNDU+XSBmaW5k
X3ZtYV9saW5rcysweDE3LzB4N2QKWyAgICA4LjI1NjAxNV0gUEdEIDFiNjMwNjcgUFVEIDFi
NjUwNjcgUE1EIDAgClsgICAgOC4yNTYwMTVdIE9vcHM6IDAwMDAgWyMxXSBERUJVR19QQUdF
QUxMT0MKWyAgICA4LjI1NjAxNV0gQ1BVOiAwIFBJRDogMTU1IENvbW06IG1vdW50IE5vdCB0
YWludGVkIDMuMTcuMC1yYzEtMDAzNzUtZ2MwNjk4YjcgIzEKWyAgICA4LjI1NjAxNV0gSGFy
ZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDgu
MjU2MDE1XSB0YXNrOiBmZmZmODgwMDBiYjllMDAwIHRpOiBmZmZmODgwMDBiYmI4MDAwIHRh
c2sudGk6IGZmZmY4ODAwMGJiYjgwMDAKWyAgICA4LjI1NjAxNV0gUklQOiAwMDEwOls8ZmZm
ZmZmZmY4MTE1Y2U0NT5dICBbPGZmZmZmZmZmODExNWNlNDU+XSBmaW5kX3ZtYV9saW5rcysw
eDE3LzB4N2QKWyAgICA4LjI1NjAxNV0gUlNQOiAwMDE4OmZmZmY4ODAwMGJiYmJkZTggIEVG
TEFHUzogMDAwMTAyMDIKWyAgICA4LjI1NjAxNV0gUkFYOiAwMDAwMDAwMDAwMDAwMDAxIFJC
WDogMDAwMDAwMDAwMDAwMDA3MyBSQ1g6IGZmZmY4ODAwMGJiYmJlMzAKWyAgICA4LjI1NjAx
NV0gUkRYOiAwMDAwN2YxMGI5ZmM2MDAwIFJTSTogMDAwMDdmMTBiOWZjNTAwMCBSREk6IGZm
ZmY4ODAwMGJhZmVhYjAKWyAgICA4LjI1NjAxNV0gUkJQOiBmZmZmODgwMDBiYmJiZGU4IFIw
ODogZmZmZjg4MDAwYmJiYmUzOCBSMDk6IGZmZmY4ODAwMGJiYmJlNDAKWyAgICA4LjI1NjAx
NV0gUjEwOiBmZmZmODgwMDBiYWZlYWE4IFIxMTogZmZmZjg4MDAwYmFmZWFhOCBSMTI6IDAw
MDAwMDAwMDAwMDAwMDAKWyAgICA4LjI1NjAxNV0gUjEzOiBmZmZmODgwMDBiYmQ2YTQwIFIx
NDogMDAwMDdmMTBiOWZjNTAwMCBSMTU6IDAwMDAwMDAwMDAwMDEwMDAKWyAgICA4LjI1NjAx
NV0gRlM6ICAwMDAwN2YxMGI5ZmJmODAwKDAwMDApIEdTOmZmZmZmZmZmODFiN2MwMDAoMDAw
MCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDguMjU2MDE1XSBDUzogIDAwMTAgRFM6
IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzClsgICAgOC4yNTYwMTVdIENS
MjogZmZmZmZmZmZmZmZmZmZlOSBDUjM6IDAwMDAwMDAwMGJiYjcwMDAgQ1I0OiAwMDAwMDAw
MDAwMDQwNmIwClsgICAgOC4yNTYwMTVdIFN0YWNrOgpbICAgIDguMjU2MDE1XSAgZmZmZjg4
MDAwYmJiYmU3MCBmZmZmZmZmZjgxMTYwODJiIDAwMDAwMDAwMDAwMDAwMDEgMDAwMDAwMDAw
MDAwMTAwMApbICAgIDguMjU2MDE1XSAgMDAwMDAwMDAwMDAwMTAwMCAwMDAwMDAwN2YxMGI5
ZmM1IDAwMDA3ZjEwYjlmYzYwMDAgMDAwMDAwMDAwMDAwMDAwMQpbICAgIDguMjU2MDE1XSAg
MDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAxMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAw
MDAwMDAwMDAwMTAwMApbICAgIDguMjU2MDE1XSBDYWxsIFRyYWNlOgpbICAgIDguMjU2MDE1
XSAgWzxmZmZmZmZmZjgxMTYwODJiPl0gbW1hcF9yZWdpb24rMHgxNTEvMHg2OWUKWyAgICA4
LjI1NjAxNV0gIFs8ZmZmZmZmZmY4MTE2MTEzND5dIGRvX21tYXBfcGdvZmYrMHgzYmMvMHg0
M2EKWyAgICA4LjI1NjAxNV0gIFs8ZmZmZmZmZmY4MTE0YmIyYT5dIHZtX21tYXBfcGdvZmYr
MHg3Mi8weGJiClsgICAgOC4yNTYwMTVdICBbPGZmZmZmZmZmODExNWVhNGU+XSBTeVNfbW1h
cF9wZ29mZisweDkyLzB4ZTEKWyAgICA4LjI1NjAxNV0gIFs8ZmZmZmZmZmY4MTAwOTEwYT5d
IFN5U19tbWFwKzB4MjQvMHgzNwpbICAgIDguMjU2MDE1XSAgWzxmZmZmZmZmZjgxNzJkZDkx
Pl0gdHJhY2VzeXMrMHhkMy8weGQ4ClsgICAgOC4yNTYwMTVdIENvZGU6IDFiIDQ4IGZmIDA1
IDZlIDUxIGI1IDAxIDQ4IDgzIGUzIGZjIDQ4IDg1IGRiIDc1IGNjIDViIDVkIGMzIDU1IDQ4
IDgzIGM3IDA4IDQ1IDMxIGQyIDQ1IDMxIGRiIDQ4IDg5IGU1IGViIDMxIDQ4IGZmIDA1IDFi
IDUyIGI1IDAxIDw0OD4gMzkgNzAgZTggNzYgMGMgNDggMzkgNTAgZTAgNzIgNTMgNDggOGQg
NzggMTAgZWIgMGUgNDggZmYgMDUgClsgICAgOC4yNTYwMTVdIFJJUCAgWzxmZmZmZmZmZjgx
MTVjZTQ1Pl0gZmluZF92bWFfbGlua3MrMHgxNy8weDdkClsgICAgOC4yNTYwMTVdICBSU1Ag
PGZmZmY4ODAwMGJiYmJkZTg+ClsgICAgOC4yNTYwMTVdIENSMjogZmZmZmZmZmZmZmZmZmZl
OQpbICAgIDguMjU2MDE1XSAtLS1bIGVuZCB0cmFjZSA4OTBiZmM4ODQ3MWQ5Zjg3IF0tLS0K
WyAgICA4LjI1NjAxNV0gQlVHOiBzbGVlcGluZyBmdW5jdGlvbiBjYWxsZWQgZnJvbSBpbnZh
bGlkIGNvbnRleHQgYXQga2VybmVsL2xvY2tpbmcvcndzZW0uYzo0MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy9jMDY5OGI3ZDk4NDdlMGNiYzQ2ODgxMzY4ZWM5
YzcyNDc0OTY4YWQ4L2RtZXNnLXF1YW50YWwta2J1aWxkLTQ6MjAxNDA4MTkxNTA2NTE6eDg2
XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzOjMuMTcuMC1yYzEtMDAzNzUtZ2MwNjk4Yjc6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy9jMDY5OGI3ZDk4NDdl
MGNiYzQ2ODgxMzY4ZWM5YzcyNDc0OTY4YWQ4L2RtZXNnLXF1YW50YWwta2J1aWxkLTY6MjAx
NDA4MTkxNTA1MDI6eDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzOjMuMTcuMC1yYzEt
MDAzNzUtZ2MwNjk4Yjc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcx
My9jMDY5OGI3ZDk4NDdlMGNiYzQ2ODgxMzY4ZWM5YzcyNDc0OTY4YWQ4L2RtZXNnLXF1YW50
YWwta2J1aWxkLTI2OjIwMTQwODE5MTUwNTQ0Ong4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4
MTcxMzozLjE3LjAtcmMxLTAwMzc1LWdjMDY5OGI3OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1pYjEtMDgxODE3MTMvYzA2OThiN2Q5ODQ3ZTBjYmM0Njg4MTM2OGVjOWM3MjQ3NDk2
OGFkOC9kbWVzZy1xdWFudGFsLWtidWlsZC04OjIwMTQwODE5MTUwNDAyOng4Nl82NC1yYW5k
Y29uZmlnLWliMS0wODE4MTcxMzozLjE3LjAtcmMxLTAwMzc1LWdjMDY5OGI3OjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvYzA2OThiN2Q5ODQ3ZTBjYmM0Njg4
MTM2OGVjOWM3MjQ3NDk2OGFkOC9kbWVzZy1xdWFudGFsLWtidWlsZC0xNjoyMDE0MDgxOTE1
MDcxMjp4ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTM6My4xNy4wLXJjMS0wMDM3NS1n
YzA2OThiNzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzL2MwNjk4
YjdkOTg0N2UwY2JjNDY4ODEzNjhlYzljNzI0NzQ5NjhhZDgvZG1lc2ctcXVhbnRhbC1rYnVp
bGQtMTY6MjAxNDA4MTkxNTA1MDc6eDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzOjMu
MTcuMC1yYzEtMDAzNzUtZ2MwNjk4Yjc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWli
MS0wODE4MTcxMy9jMDY5OGI3ZDk4NDdlMGNiYzQ2ODgxMzY4ZWM5YzcyNDc0OTY4YWQ4L2Rt
ZXNnLXF1YW50YWwta2J1aWxkLTE3OjIwMTQwODE5MTUwNjE1Ong4Nl82NC1yYW5kY29uZmln
LWliMS0wODE4MTcxMzozLjE3LjAtcmMxLTAwMzc1LWdjMDY5OGI3OjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvYzA2OThiN2Q5ODQ3ZTBjYmM0Njg4MTM2OGVj
OWM3MjQ3NDk2OGFkOC9kbWVzZy1xdWFudGFsLWtidWlsZC0yNToyMDE0MDgxOTE1MDU0NTp4
ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTM6My4xNy4wLXJjMS0wMDM3NS1nYzA2OThi
NzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzL2MwNjk4YjdkOTg0
N2UwY2JjNDY4ODEzNjhlYzljNzI0NzQ5NjhhZDgvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTA6
MjAxNDA4MTkxNTA1Mjc6eDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzOjMuMTcuMC1y
YzEtMDAzNzUtZ2MwNjk4Yjc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4
MTcxMy9jMDY5OGI3ZDk4NDdlMGNiYzQ2ODgxMzY4ZWM5YzcyNDc0OTY4YWQ4L2RtZXNnLXF1
YW50YWwta2J1aWxkLTIxOjIwMTQwODE5MTUwNDU1Ong4Nl82NC1yYW5kY29uZmlnLWliMS0w
ODE4MTcxMzozLjE3LjAtcmMxLTAwMzc1LWdjMDY5OGI3OjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1pYjEtMDgxODE3MTMvYzA2OThiN2Q5ODQ3ZTBjYmM0Njg4MTM2OGVjOWM3MjQ3
NDk2OGFkOC9kbWVzZy1xdWFudGFsLWtidWlsZC05OjIwMTQwODE5MTUwNTI5Ong4Nl82NC1y
YW5kY29uZmlnLWliMS0wODE4MTcxMzozLjE3LjAtcmMxLTAwMzc1LWdjMDY5OGI3OjEKMjox
MToyOTggYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogNzAgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpCltmNTUwNTg0
NjNhNTdhNTllOGI1YTU5ZjhiNGFlMTg3NWM3YTkxYTQ0XSBNZXJnZSByZW1vdGUtdHJhY2tp
bmcgYnJhbmNoICdmc2NhY2hlL2ZzY2FjaGUnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC00L29iai1i
aXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLWliMS0wODE4MTcxMy9uZXh0Om1hc3RlcjpmNTUwNTg0NjNhNTdhNTllOGI1YTU5Zjhi
NGFlMTg3NWM3YTkxYTQ0OmJpc2VjdC1saW51eC00CgoyMDE0LTA4LTE5IDE4OjA2OjIwIGY1
NTA1ODQ2M2E1N2E1OWU4YjVhNTlmOGI0YWUxODc1YzdhOTFhNDQgcmV1c2UgL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvZjU1MDU4NDYzYTU3YTU5ZThiNWE1OWY4
YjRhZTE4NzVjN2E5MWE0NC92bWxpbnV6LTMuMTcuMC1yYzEtMDAzMjUtZ2Y1NTA1ODQKCjIw
MTQtMDgtMTkgMTg6MDY6MjEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTMwMQkzMjUJMzY5
CTM3OAkzODUJMzkyCTQxNAk0NTIJNDgyCTUwMgk1NTcJNjE2CTcwOAk4MDAJODY1CTg4Mgk5
MDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA1MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgNiBzdGVwcykKWzc2YmIxMjQxYmVjNWY1OTdiMDI1Yjk5N2Q2YWU3
ZTE5M2RhYjgyODldIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2xvZ2ZzL21hc3Rl
cicKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTQvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzL25leHQ6bWFz
dGVyOjc2YmIxMjQxYmVjNWY1OTdiMDI1Yjk5N2Q2YWU3ZTE5M2RhYjgyODk6YmlzZWN0LWxp
bnV4LTQKCjIwMTQtMDgtMTkgMTg6MTY6MjQgNzZiYjEyNDFiZWM1ZjU5N2IwMjViOTk3ZDZh
ZTdlMTkzZGFiODI4OSByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4
MTcxMy83NmJiMTI0MWJlYzVmNTk3YjAyNWI5OTdkNmFlN2UxOTNkYWI4Mjg5L3ZtbGludXot
My4xNy4wLXJjMS0wMDMzMS1nNzZiYjEyNAoKMjAxNC0wOC0xOSAxODoxNjoyNCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuCTMwNQkzNTkJMzg2CTQyOQk0NTcJNTA2CTU2OQk1OTkJNjExCTYz
MAk2MzUJNjM2Li4JNjQ1CTY0OAk2NDkJNjUwLgk2NTUJNjYxCTY3MAk2ODIJNjk2CTcxOQk3
MzgJNzY4CTgwMwk4MzgJODc2CTg4NAk5MDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0NCByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBzdGVwcykKWzkwMTZj
ZWI0YjM2OTliYzk1ZmZhZWVkMzcxZTVmZDA3NDViYWIyMjRdIE1lcmdlIHJlbW90ZS10cmFj
a2luZyBicmFuY2ggJ3Zmcy9mb3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTQvb2JqLWJp
c2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctaWIxLTA4MTgxNzEzL25leHQ6bWFzdGVyOjkwMTZjZWI0YjM2OTliYzk1ZmZhZWVkMzcx
ZTVmZDA3NDViYWIyMjQ6YmlzZWN0LWxpbnV4LTQKIFRFU1QgRkFJTFVSRQpbICAgIDAuMDAw
MDAwXSBBQ1BJOiBFYXJseSB0YWJsZSBjaGVja3N1bSB2ZXJpZmljYXRpb24gZGlzYWJsZWQK
WyAgICAwLjAwMDAwMF0gQUNQSTogUlNEUCAweDAwMDAwMDAwMDAwRjBDOTAgMDAwMDE0ICh2
MDAgQk9DSFMgKQpbICAgIDAuMDAwMDAwXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0t
LS0tLS0tLS0KWyAgICAwLjAwMDAwMF0gV0FSTklORzogQ1BVOiAwIFBJRDogMCBhdCBtbS9l
YXJseV9pb3JlbWFwLmM6MTM2IF9fZWFybHlfaW9yZW1hcCsweDE0Mi8weDJhOSgpClsgICAg
MC4wMDAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE3
LjAtcmMxLTAwMzUzLWc5MDE2Y2ViICMxClsgICAgMC4wMDAwMDBdIEhhcmR3YXJlIG5hbWU6
IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgsIDE5OTYpLCBCSU9TIDEuNy41LTIw
MTQwNTMxXzA4MzAzMC1nYW5kYWxmIDA0LzAxLzIwMTQKWyAgICAwLjAwMDAwMF0gIDAwMDAw
MDAwMDAwMDAwMDAgZmZmZmZmZmY4MWI0ZmQzMCBmZmZmZmZmZjgxNzE1MzNkIGZmZmZmZmZm
ODFiNGZkNjgKWyAgICAwLjAwMDAwMF0gIGZmZmZmZmZmODEwOGNkZDkgZmZmZmZmZmY4MWU3
MTExYyAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwYmI1ODkKWyAgICAwLjAwMDAwMF0g
IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmZmZmZjgxYjRmZDc4IGZm
ZmZmZmZmODEwOGNmMTQKWyAgICAwLjAwMDAwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MTcxNTMzZD5dIGR1bXBfc3RhY2srMHgyZS8weDNlClsgICAgMC4w
MDAwMDBdICBbPGZmZmZmZmZmODEwOGNkZDk+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDhj
LzB4YmEKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU3MTExYz5dID8gX19lYXJseV9p
b3JlbWFwKzB4MTQyLzB4MmE5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwOGNmMTQ+
XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyMy8weDJjClsgICAgMC4wMDAwMDBdICBbPGZmZmZm
ZmZmODFlNzExMWM+XSBfX2Vhcmx5X2lvcmVtYXArMHgxNDIvMHgyYTkKWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MTcyY2I3MT5dID8gX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3Jl
KzB4NWUvMHg5ZQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTcxNTlkPl0gZWFybHlf
aW9yZW1hcCsweDFhLzB4MjMKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU1Yzc3MT5d
IF9fYWNwaV9tYXBfdGFibGUrMHgyMS8weDJmClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZm
ODE3MGIxNTA+XSBhY3BpX29zX21hcF9pb21lbSsweDI4LzB4MjAyClsgICAgMC4wMDAwMDBd
ICBbPGZmZmZmZmZmODE3MGIzM2E+XSBhY3BpX29zX21hcF9tZW1vcnkrMHgxMC8weDE5Clsg
ICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlN2JhMDU+XSBhY3BpX3RiX3BhcnNlX3Jvb3Rf
dGFibGUrMHgxNGYvMHgyN2UKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU3YmJjMj5d
IGFjcGlfaW5pdGlhbGl6ZV90YWJsZXMrMHg4ZS8weDliClsgICAgMC4wMDAwMDBdICBbPGZm
ZmZmZmZmODFlNzk2YTI+XSBhY3BpX3RhYmxlX2luaXQrMHg2Yy8weDEzNgpbICAgIDAuMDAw
MDAwXSAgWzxmZmZmZmZmZjgxZTVjODk3Pl0gYWNwaV9ib290X3RhYmxlX2luaXQrMHgzNy8w
eGY5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlNTFmZDg+XSBzZXR1cF9hcmNoKzB4
Y2I5LzB4MTE0NgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTRkZjkxPl0gc3RhcnRf
a2VybmVsKzB4ZTgvMHg2OGIKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU0ZDEyMD5d
ID8gZWFybHlfaWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4wMDAwMDBdICBbPGZm
ZmZmZmZmODFlNGQ1OWM+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25zKzB4NDYvMHg0Zgpb
ICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTRkNmYzPl0geDg2XzY0X3N0YXJ0X2tlcm5l
bCsweDE0ZS8weDE2MgpbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFjZSA2ZDVmM2U1ZWY1
MjVmYzllIF0tLS0KWyAgICAwLjAwMDAwMF0ga3ZtLWNsb2NrOiBVc2luZyBtc3JzIDRiNTY0
ZDAxIGFuZCA0YjU2NGQwMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcx
My85MDE2Y2ViNGIzNjk5YmM5NWZmYWVlZDM3MWU1ZmQwNzQ1YmFiMjI0L2RtZXNnLXF1YW50
YWwtdnAtMjE6MjAxNDA4MTkxNzIyMzk6eDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEz
OjMuMTcuMC1yYzEtMDAzNTMtZzkwMTZjZWI6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWliMS0wODE4MTcxMy85MDE2Y2ViNGIzNjk5YmM5NWZmYWVlZDM3MWU1ZmQwNzQ1YmFiMjI0
L2RtZXNnLXF1YW50YWwtaXZiNDQtNTM6MjAxNDA4MTkxNzI0NDE6eDg2XzY0LXJhbmRjb25m
aWctaWIxLTA4MTgxNzEzOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3
MTMvOTAxNmNlYjRiMzY5OWJjOTVmZmFlZWQzNzFlNWZkMDc0NWJhYjIyNC9kbWVzZy1xdWFu
dGFsLWxrcC1uZXgwNC0yOjIwMTQwODE5MTc0MzQ5Ong4Nl82NC1yYW5kY29uZmlnLWliMS0w
ODE4MTcxMzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLzkwMTZj
ZWI0YjM2OTliYzk1ZmZhZWVkMzcxZTVmZDA3NDViYWIyMjQvZG1lc2ctcXVhbnRhbC1pdmI0
NC03NzoyMDE0MDgxOTE3MTk0OTp4ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTM6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy85MDE2Y2ViNGIzNjk5YmM5
NWZmYWVlZDM3MWU1ZmQwNzQ1YmFiMjI0L2RtZXNnLXF1YW50YWwtaXZiNDQtNjM6MjAxNDA4
MTkxNzIyMTU6eDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzOjoKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvOTAxNmNlYjRiMzY5OWJjOTVmZmFlZWQzNzFl
NWZkMDc0NWJhYjIyNC9kbWVzZy1xdWFudGFsLXZwLTI2OjIwMTQwODE5MTc0MjQ4Ong4Nl82
NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMzozLjE3LjAtcmMxLTAwMzUzLWc5MDE2Y2ViOjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvOTAxNmNlYjRiMzY5OWJj
OTVmZmFlZWQzNzFlNWZkMDc0NWJhYjIyNC9kbWVzZy1xdWFudGFsLWl2YjQ0LTEwMzoyMDE0
MDgxOTE3MjMwNzp4ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTM6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy85MDE2Y2ViNGIzNjk5YmM5NWZmYWVlZDM3
MWU1ZmQwNzQ1YmFiMjI0L2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTQwOjIwMTQwODE5MTc0
MzE2Ong4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMzo6Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaWIxLTA4MTgxNzEzLzkwMTZjZWI0YjM2OTliYzk1ZmZhZWVkMzcxZTVmZDA3
NDViYWIyMjQvZG1lc2ctcXVhbnRhbC1pdmI0NC03MjoyMDE0MDgxOTE3NDI0Njp4ODZfNjQt
cmFuZGNvbmZpZy1pYjEtMDgxODE3MTM6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWli
MS0wODE4MTcxMy85MDE2Y2ViNGIzNjk5YmM5NWZmYWVlZDM3MWU1ZmQwNzQ1YmFiMjI0L2Rt
ZXNnLXF1YW50YWwtbGtwLW5leDA0LTY1OjIwMTQwODE5MTczOTQ1Ong4Nl82NC1yYW5kY29u
ZmlnLWliMS0wODE4MTcxMzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgx
NzEzLzkwMTZjZWI0YjM2OTliYzk1ZmZhZWVkMzcxZTVmZDA3NDViYWIyMjQvZG1lc2ctcXVh
bnRhbC1pdmI0NC0xMjY6MjAxNDA4MTkxNzQzMjg6eDg2XzY0LXJhbmRjb25maWctaWIxLTA4
MTgxNzEzOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvOTAxNmNl
YjRiMzY5OWJjOTVmZmFlZWQzNzFlNWZkMDc0NWJhYjIyNC9kbWVzZy1xdWFudGFsLWl2YjQ0
LTIxOjIwMTQwODE5MTcxOTI1Ong4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMzo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLzkwMTZjZWI0YjM2OTliYzk1
ZmZhZWVkMzcxZTVmZDA3NDViYWIyMjQvZG1lc2ctcXVhbnRhbC1pdmI0NC03ODoyMDE0MDgx
OTE3NDE1Mjp4ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTM6Ogova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy85MDE2Y2ViNGIzNjk5YmM5NWZmYWVlZDM3MWU1
ZmQwNzQ1YmFiMjI0L2RtZXNnLXF1YW50YWwtaXZiNDEtNDg6MjAxNDA4MTkxNzQzNDU6eDg2
XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1pYjEtMDgxODE3MTMvOTAxNmNlYjRiMzY5OWJjOTVmZmFlZWQzNzFlNWZkMDc0NWJhYjIy
NC9kbWVzZy1xdWFudGFsLXZwLTI4OjIwMTQwODE5MTc0MjAwOng4Nl82NC1yYW5kY29uZmln
LWliMS0wODE4MTcxMzozLjE3LjAtcmMxLTAwMzUzLWc5MDE2Y2ViOjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvOTAxNmNlYjRiMzY5OWJjOTVmZmFlZWQzNzFl
NWZkMDc0NWJhYjIyNC9kbWVzZy1xdWFudGFsLWl2YjQ0LTgzOjIwMTQwODE5MTcyNTEwOng4
Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaWIxLTA4MTgxNzEzLzkwMTZjZWI0YjM2OTliYzk1ZmZhZWVkMzcxZTVmZDA3NDViYWIy
MjQvZG1lc2ctcXVhbnRhbC12cC0xNDoyMDE0MDgxOTE3MjUxMTp4ODZfNjQtcmFuZGNvbmZp
Zy1pYjEtMDgxODE3MTM6My4xNy4wLXJjMS0wMDM1My1nOTAxNmNlYjoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLzkwMTZjZWI0YjM2OTliYzk1ZmZhZWVkMzcx
ZTVmZDA3NDViYWIyMjQvZG1lc2ctcXVhbnRhbC1pdmI0NC0xMTY6MjAxNDA4MTkxNzI1Mjg6
eDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1pYjEtMDgxODE3MTMvOTAxNmNlYjRiMzY5OWJjOTVmZmFlZWQzNzFlNWZkMDc0NWJh
YjIyNC9kbWVzZy1xdWFudGFsLWtidWlsZC0zMDoyMDE0MDgxOTE3MjEzMTp4ODZfNjQtcmFu
ZGNvbmZpZy1pYjEtMDgxODE3MTM6My4xNy4wLXJjMS0wMDM1My1nOTAxNmNlYjoxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLzkwMTZjZWI0YjM2OTliYzk1ZmZh
ZWVkMzcxZTVmZDA3NDViYWIyMjQvZG1lc2ctcXVhbnRhbC12cC00OjIwMTQwODE5MTczODU4
Ong4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMzozLjE3LjAtcmMxLTAwMzUzLWc5MDE2
Y2ViOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvOTAxNmNlYjRi
MzY5OWJjOTVmZmFlZWQzNzFlNWZkMDc0NWJhYjIyNC9kbWVzZy1xdWFudGFsLWxrcC1uZXgw
NC0xNTk6MjAxNDA4MTkxNzQzNDE6eDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzOjoK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvOTAxNmNlYjRiMzY5OWJj
OTVmZmFlZWQzNzFlNWZkMDc0NWJhYjIyNC9kbWVzZy1xdWFudGFsLXZwLTEwOjIwMTQwODE5
MTcxOTE0Ong4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMzozLjE3LjAtcmMxLTAwMzUz
LWc5MDE2Y2ViOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvOTAx
NmNlYjRiMzY5OWJjOTVmZmFlZWQzNzFlNWZkMDc0NWJhYjIyNC9kbWVzZy1xdWFudGFsLWxr
cC1uZXgwNC01MzoyMDE0MDgxOTE3NDIzNDp4ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3
MTM6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy85MDE2Y2ViNGIz
Njk5YmM5NWZmYWVlZDM3MWU1ZmQwNzQ1YmFiMjI0L2RtZXNnLXF1YW50YWwtbGtwLW5leDA0
LTM0OjIwMTQwODE5MTc0MDI4Ong4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMzo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLzkwMTZjZWI0YjM2OTliYzk1
ZmZhZWVkMzcxZTVmZDA3NDViYWIyMjQvZG1lc2ctcXVhbnRhbC1pdmI0NC01MjoyMDE0MDgx
OTE3MjQwMDp4ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTM6Ogova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy85MDE2Y2ViNGIzNjk5YmM5NWZmYWVlZDM3MWU1
ZmQwNzQ1YmFiMjI0L2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTQxOjIwMTQwODE5MTczOTQ1
Ong4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaWIxLTA4MTgxNzEzLzkwMTZjZWI0YjM2OTliYzk1ZmZhZWVkMzcxZTVmZDA3NDVi
YWIyMjQvZG1lc2ctcXVhbnRhbC1pdmI0NC04ODoyMDE0MDgxOTE3NDMwMDp4ODZfNjQtcmFu
ZGNvbmZpZy1pYjEtMDgxODE3MTM6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0w
ODE4MTcxMy85MDE2Y2ViNGIzNjk5YmM5NWZmYWVlZDM3MWU1ZmQwNzQ1YmFiMjI0L2RtZXNn
LXF1YW50YWwta2J1aWxkLTE2OjIwMTQwODE5MTcyMDExOng4Nl82NC1yYW5kY29uZmlnLWli
MS0wODE4MTcxMzozLjE3LjAtcmMxLTAwMzUzLWc5MDE2Y2ViOjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvOTAxNmNlYjRiMzY5OWJjOTVmZmFlZWQzNzFlNWZk
MDc0NWJhYjIyNC9kbWVzZy1xdWFudGFsLWl2YjQ0LTk3OjIwMTQwODE5MTc0MjQ2Ong4Nl82
NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMzo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aWIxLTA4MTgxNzEzLzkwMTZjZWI0YjM2OTliYzk1ZmZhZWVkMzcxZTVmZDA3NDViYWIyMjQv
ZG1lc2ctcXVhbnRhbC1pdmI0NC0xMDY6MjAxNDA4MTkxNzIwMDI6eDg2XzY0LXJhbmRjb25m
aWctaWIxLTA4MTgxNzEzOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3
MTMvOTAxNmNlYjRiMzY5OWJjOTVmZmFlZWQzNzFlNWZkMDc0NWJhYjIyNC9kbWVzZy1xdWFu
dGFsLWtidWlsZC0xMjoyMDE0MDgxOTE3MjM0Nzp4ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgx
ODE3MTM6My4xNy4wLXJjMS0wMDM1My1nOTAxNmNlYjoxCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaWIxLTA4MTgxNzEzLzkwMTZjZWI0YjM2OTliYzk1ZmZhZWVkMzcxZTVmZDA3NDVi
YWIyMjQvZG1lc2ctcXVhbnRhbC1pdmI0NC01NjoyMDE0MDgxOTE3NDM1ODp4ODZfNjQtcmFu
ZGNvbmZpZy1pYjEtMDgxODE3MTM6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0w
ODE4MTcxMy85MDE2Y2ViNGIzNjk5YmM5NWZmYWVlZDM3MWU1ZmQwNzQ1YmFiMjI0L2RtZXNn
LXF1YW50YWwtaXZiNDQtODI6MjAxNDA4MTkxNzIzMzA6eDg2XzY0LXJhbmRjb25maWctaWIx
LTA4MTgxNzEzOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvOTAx
NmNlYjRiMzY5OWJjOTVmZmFlZWQzNzFlNWZkMDc0NWJhYjIyNC9kbWVzZy1xdWFudGFsLWxr
cC1uZXgwNC0xMzoyMDE0MDgxOTE3NDIxMTp4ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3
MTM6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy85MDE2Y2ViNGIz
Njk5YmM5NWZmYWVlZDM3MWU1ZmQwNzQ1YmFiMjI0L2RtZXNnLXF1YW50YWwta2J1aWxkLTQ6
MjAxNDA4MTkxNzIyMjc6eDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzOjMuMTcuMC1y
YzEtMDAzNTMtZzkwMTZjZWI6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4
MTcxMy85MDE2Y2ViNGIzNjk5YmM5NWZmYWVlZDM3MWU1ZmQwNzQ1YmFiMjI0L2RtZXNnLXF1
YW50YWwta2J1aWxkLTEyOjIwMTQwODE5MTc0MDM5Ong4Nl82NC1yYW5kY29uZmlnLWliMS0w
ODE4MTcxMzozLjE3LjAtcmMxLTAwMzUzLWc5MDE2Y2ViOjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1pYjEtMDgxODE3MTMvOTAxNmNlYjRiMzY5OWJjOTVmZmFlZWQzNzFlNWZkMDc0
NWJhYjIyNC9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC0xMDk6MjAxNDA4MTkxNzQxNTg6eDg2
XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1pYjEtMDgxODE3MTMvOTAxNmNlYjRiMzY5OWJjOTVmZmFlZWQzNzFlNWZkMDc0NWJhYjIy
NC9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC01MToyMDE0MDgxOTE3NDIwODp4ODZfNjQtcmFu
ZGNvbmZpZy1pYjEtMDgxODE3MTM6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0w
ODE4MTcxMy85MDE2Y2ViNGIzNjk5YmM5NWZmYWVlZDM3MWU1ZmQwNzQ1YmFiMjI0L2RtZXNn
LXF1YW50YWwtaXZiNDQtODY6MjAxNDA4MTkxNzIyMzc6eDg2XzY0LXJhbmRjb25maWctaWIx
LTA4MTgxNzEzOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvOTAx
NmNlYjRiMzY5OWJjOTVmZmFlZWQzNzFlNWZkMDc0NWJhYjIyNC9kbWVzZy1xdWFudGFsLWl2
YjQ0LTEwNzoyMDE0MDgxOTE3MjAyNDp4ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTM6
Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy85MDE2Y2ViNGIzNjk5
YmM5NWZmYWVlZDM3MWU1ZmQwNzQ1YmFiMjI0L2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTk5
OjIwMTQwODE5MTc0MzQ5Ong4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMzo6CjI6NDE6
MTE5NyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKbGluZWFyLWJpc2VjdDogYmFkIGJy
YW5jaCBtYXkgYmUgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAndmZzL2Zvci1uZXh0JwpsaW5l
YXItYmlzZWN0OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0CmxpbmVhci1iaXNlY3Q6IGdp
dCBiaXNlY3Qgc3RhcnQgOTAxNmNlYjRiMzY5OWJjOTVmZmFlZWQzNzFlNWZkMDc0NWJhYjIy
NCA3NmJiMTI0MWJlYzVmNTk3YjAyNWI5OTdkNmFlN2UxOTNkYWI4Mjg5IC0tClByZXZpb3Vz
IEhFQUQgcG9zaXRpb24gd2FzIDkwMTZjZWIuLi4gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJy
YW5jaCAndmZzL2Zvci1uZXh0JwpIRUFEIGlzIG5vdyBhdCAxNzFjMDYyLi4uIE1lcmdlIHRh
ZyAnbW1jLXYzLjE2LTInIG9mIGdpdDovL2dpdC5saW5hcm8ub3JnL3Blb3BsZS91bGYuaGFu
c3Nvbi9tbWMKQmlzZWN0aW5nOiAxMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgNCBzdGVwcykKWzc2YThhNDUyNDFiZTJhZmYzODk0NGU3NDgxMWUyM2Qx
MDI0YTcxZmFdIHZmczogTWFrZSBkX2ludmFsaWRhdGUgcmV0dXJuIHZvaWQKbGluZWFyLWJp
c2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC00L29iai1iaXNlY3QKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlz
ZWN0L2xpbnV4LTQvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzL25leHQ6bWFzdGVyOjc2YThhNDUy
NDFiZTJhZmYzODk0NGU3NDgxMWUyM2QxMDI0YTcxZmE6YmlzZWN0LWxpbnV4LTQKCjIwMTQt
MDgtMTkgMTg6MzM6MDIgNzZhOGE0NTI0MWJlMmFmZjM4OTQ0ZTc0ODExZTIzZDEwMjRhNzFm
YSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMtNzZhOGE0NTI0MWJlMmFmZjM4
OTQ0ZTc0ODExZTIzZDEwMjRhNzFmYQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLzc2YThhNDUyNDFiZTJhZmYzODk0NGU3NDgx
MWUyM2QxMDI0YTcxZmEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy03NmE4YTQ1MjQx
YmUyYWZmMzg5NDRlNzQ4MTFlMjNkMTAyNGE3MWZhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci94ODZfNjQt
cmFuZGNvbmZpZy1pYjEtMDgxODE3MTMtNzZhOGE0NTI0MWJlMmFmZjM4OTQ0ZTc0ODExZTIz
ZDEwMjRhNzFmYQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgx
NzEzLzc2YThhNDUyNDFiZTJhZmYzODk0NGU3NDgxMWUyM2QxMDI0YTcxZmEvdm1saW51ei0z
LjE2LjAtMTAzNjMtZzc2YThhNDUKCjIwMTQtMDgtMTkgMTg6Mzg6MDIgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgCTQJNDQgVEVTVCBGQUlMVVJFClsgICAgMC4wMDAwMDBdIEFDUEk6IEVhcmx5
IHRhYmxlIGNoZWNrc3VtIHZlcmlmaWNhdGlvbiBkaXNhYmxlZApbICAgIDAuMDAwMDAwXSBB
Q1BJOiBSU0RQIDB4MDAwMDAwMDAwMDBGMEM5MCAwMDAwMTQgKHYwMCBCT0NIUyApClsgICAg
MC4wMDAwMDBdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAu
MDAwMDAwXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAwIGF0IG1tL2Vhcmx5X2lvcmVtYXAuYzox
MzYgX19lYXJseV9pb3JlbWFwKzB4MTQyLzB4MmE5KCkKWyAgICAwLjAwMDAwMF0gQ1BVOiAw
IFBJRDogMCBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTYuMC0xMDM2My1nNzZhOGE0
NSAjMQpbICAgIDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChp
NDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyAxLjcuNS0yMDE0MDUzMV8wODMwMzAtZ2FuZGFs
ZiAwNC8wMS8yMDE0ClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMDAwMDAwMDAwIGZmZmZmZmZm
ODFiNGZkMzAgZmZmZmZmZmY4MTcxNTdhZCBmZmZmZmZmZjgxYjRmZDY4ClsgICAgMC4wMDAw
MDBdICBmZmZmZmZmZjgxMDhjZTM5IGZmZmZmZmZmODFlNzBkYjMgMDAwMDAwMDAwMDAwMDAw
MCAwMDAwMDAwMDAwMGJiNTg5ClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMDAwMDAwMDAwIDAw
MDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MWI0ZmQ3OCBmZmZmZmZmZjgxMDhjZjc0ClsgICAg
MC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODE3MTU3
YWQ+XSBkdW1wX3N0YWNrKzB4MmUvMHgzZQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgx
MDhjZTM5Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg4Yy8weGJhClsgICAgMC4wMDAwMDBd
ICBbPGZmZmZmZmZmODFlNzBkYjM+XSA/IF9fZWFybHlfaW9yZW1hcCsweDE0Mi8weDJhOQpb
ICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDhjZjc0Pl0gd2Fybl9zbG93cGF0aF9udWxs
KzB4MjMvMHgyYwpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTcwZGIzPl0gX19lYXJs
eV9pb3JlbWFwKzB4MTQyLzB4MmE5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODE3MmNm
ZTE+XSA/IF9yYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSsweDVlLzB4OWUKWyAgICAwLjAw
MDAwMF0gIFs8ZmZmZmZmZmY4MWU3MTIzND5dIGVhcmx5X2lvcmVtYXArMHgxYS8weDIzClsg
ICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlNWMyNzk+XSBfX2FjcGlfbWFwX3RhYmxlKzB4
MjEvMHgyZgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxNzBiNWMwPl0gYWNwaV9vc19t
YXBfaW9tZW0rMHgyOC8weDIwMgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxNzBiN2Fh
Pl0gYWNwaV9vc19tYXBfbWVtb3J5KzB4MTAvMHgxOQpbICAgIDAuMDAwMDAwXSAgWzxmZmZm
ZmZmZjgxZTdiNjljPl0gYWNwaV90Yl9wYXJzZV9yb290X3RhYmxlKzB4MTRmLzB4MjdlClsg
ICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlN2I4NTk+XSBhY3BpX2luaXRpYWxpemVfdGFi
bGVzKzB4OGUvMHg5YgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTc5MzM5Pl0gYWNw
aV90YWJsZV9pbml0KzB4NmMvMHgxMzYKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU1
YzhiZT5dIGFjcGlfYm9vdF90YWJsZV9pbml0KzB4MzcvMHhmOQpbICAgIDAuMDAwMDAwXSAg
WzxmZmZmZmZmZjgxZTUxZmQ4Pl0gc2V0dXBfYXJjaCsweGNiOS8weDExNDYKWyAgICAwLjAw
MDAwMF0gIFs8ZmZmZmZmZmY4MWU0ZGY5MT5dIHN0YXJ0X2tlcm5lbCsweGU4LzB4NjhiClsg
ICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlNGQxMjA+XSA/IGVhcmx5X2lkdF9oYW5kbGVy
cysweDEyMC8weDEyMApbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTRkNTljPl0geDg2
XzY0X3N0YXJ0X3Jlc2VydmF0aW9ucysweDQ2LzB4NGYKWyAgICAwLjAwMDAwMF0gIFs8ZmZm
ZmZmZmY4MWU0ZDZmMz5dIHg4Nl82NF9zdGFydF9rZXJuZWwrMHgxNGUvMHgxNjIKWyAgICAw
LjAwMDAwMF0gLS0tWyBlbmQgdHJhY2UgZmQwMTU3NmIyZTY3NDE2YyBdLS0tClsgICAgMC4w
MDAwMDBdIGt2bS1jbG9jazogVXNpbmcgbXNycyA0YjU2NGQwMSBhbmQgNGI1NjRkMDAKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvNzZhOGE0NTI0MWJlMmFmZjM4
OTQ0ZTc0ODExZTIzZDEwMjRhNzFmYS9kbWVzZy1xdWFudGFsLWtidWlsZC00OjIwMTQwODE5
MTgzNjUxOng4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMzozLjE2LjAtMTAzNjMtZzc2
YThhNDU6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy83NmE4YTQ1
MjQxYmUyYWZmMzg5NDRlNzQ4MTFlMjNkMTAyNGE3MWZhL2RtZXNnLXF1YW50YWwtaXZiNDQt
MTIxOjIwMTQwODE5MTgzODQ3Ong4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMzo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLzc2YThhNDUyNDFiZTJhZmYz
ODk0NGU3NDgxMWUyM2QxMDI0YTcxZmEvZG1lc2ctcXVhbnRhbC1pdmI0NC02OjIwMTQwODE5
MTgzODQ4Ong4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMzo6CjA6Mzo0NyBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiA1IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbODlmN2NhMWFmMTViZGZlN2E2YWVk
MzQzMDMyYTg0YWYyYTY5ZjczNl0gdmZzOiBLZWVwIGEgbGlzdCBvZiBtb3VudHMgb24gYSBt
b3VudCBwb2ludApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNC9vYmotYmlzZWN0CmxzIC1hIC9rYnVp
bGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMv
bmV4dDptYXN0ZXI6ODlmN2NhMWFmMTViZGZlN2E2YWVkMzQzMDMyYTg0YWYyYTY5ZjczNjpi
aXNlY3QtbGludXgtNAoKMjAxNC0wOC0xOSAxODozOTowNCA4OWY3Y2ExYWYxNWJkZmU3YTZh
ZWQzNDMwMzJhODRhZjJhNjlmNzM2IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcx
My04OWY3Y2ExYWYxNWJkZmU3YTZhZWQzNDMwMzJhODRhZjJhNjlmNzM2CkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvODlmN2Nh
MWFmMTViZGZlN2E2YWVkMzQzMDMyYTg0YWYyYTY5ZjczNgp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaWIx
LTA4MTgxNzEzLTg5ZjdjYTFhZjE1YmRmZTdhNmFlZDM0MzAzMmE4NGFmMmE2OWY3MzYKa2Vy
bmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy84OWY3Y2ExYWYx
NWJkZmU3YTZhZWQzNDMwMzJhODRhZjJhNjlmNzM2L3ZtbGludXotMy4xNi4wLTEwMjkxLWc4
OWY3Y2ExCgoyMDE0LTA4LTE5IDE4OjQxOjA0IGRldGVjdGluZyBib290IHN0YXRlIAk3MCBU
RVNUIEZBSUxVUkUKWyAgICAwLjAwMDAwMF0gQUNQSTogRWFybHkgdGFibGUgY2hlY2tzdW0g
dmVyaWZpY2F0aW9uIGRpc2FibGVkClsgICAgMC4wMDAwMDBdIEFDUEk6IFJTRFAgMHgwMDAw
MDAwMDAwMEYwQzkwIDAwMDAxNCAodjAwIEJPQ0hTICkKWyAgICAwLjAwMDAwMF0gLS0tLS0t
LS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4wMDAwMDBdIFdBUk5JTkc6
IENQVTogMCBQSUQ6IDAgYXQgbW0vZWFybHlfaW9yZW1hcC5jOjEzNiBfX2Vhcmx5X2lvcmVt
YXArMHgxNDIvMHgyYTkoKQpbICAgIDAuMDAwMDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3
YXBwZXIgTm90IHRhaW50ZWQgMy4xNi4wLTEwMjkxLWc4OWY3Y2ExICMxClsgICAgMC4wMDAw
MDBdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgsIDE5
OTYpLCBCSU9TIDEuNy41LTIwMTQwNTMxXzA4MzAzMC1nYW5kYWxmIDA0LzAxLzIwMTQKWyAg
ICAwLjAwMDAwMF0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MWI0ZmQzMCBmZmZmZmZm
ZjgxNzE1NjhkIGZmZmZmZmZmODFiNGZkNjgKWyAgICAwLjAwMDAwMF0gIGZmZmZmZmZmODEw
OGNlMzkgZmZmZmZmZmY4MWU3MGRiMyAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwYmI1
ODkKWyAgICAwLjAwMDAwMF0gIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCBm
ZmZmZmZmZjgxYjRmZDc4IGZmZmZmZmZmODEwOGNmNzQKWyAgICAwLjAwMDAwMF0gQ2FsbCBU
cmFjZToKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTcxNTY4ZD5dIGR1bXBfc3RhY2sr
MHgyZS8weDNlClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODEwOGNlMzk+XSB3YXJuX3Ns
b3dwYXRoX2NvbW1vbisweDhjLzB4YmEKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MWU3
MGRiMz5dID8gX19lYXJseV9pb3JlbWFwKzB4MTQyLzB4MmE5ClsgICAgMC4wMDAwMDBdICBb
PGZmZmZmZmZmODEwOGNmNzQ+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyMy8weDJjClsgICAg
MC4wMDAwMDBdICBbPGZmZmZmZmZmODFlNzBkYjM+XSBfX2Vhcmx5X2lvcmVtYXArMHgxNDIv
MHgyYTkKWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTcyY2VjMT5dID8gX3Jhd19zcGlu
X3VubG9ja19pcnFyZXN0b3JlKzB4NWUvMHg5ZQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZm
ZjgxZTcxMjM0Pl0gZWFybHlfaW9yZW1hcCsweDFhLzB4MjMKWyAgICAwLjAwMDAwMF0gIFs8
ZmZmZmZmZmY4MWU1YzI3OT5dIF9fYWNwaV9tYXBfdGFibGUrMHgyMS8weDJmClsgICAgMC4w
MDAwMDBdICBbPGZmZmZmZmZmODE3MGI0YTA+XSBhY3BpX29zX21hcF9pb21lbSsweDI4LzB4
MjAyClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODE3MGI2OGE+XSBhY3BpX29zX21hcF9t
ZW1vcnkrMHgxMC8weDE5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlN2I2OWM+XSBh
Y3BpX3RiX3BhcnNlX3Jvb3RfdGFibGUrMHgxNGYvMHgyN2UKWyAgICAwLjAwMDAwMF0gIFs8
ZmZmZmZmZmY4MWU3Yjg1OT5dIGFjcGlfaW5pdGlhbGl6ZV90YWJsZXMrMHg4ZS8weDliClsg
ICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlNzkzMzk+XSBhY3BpX3RhYmxlX2luaXQrMHg2
Yy8weDEzNgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTVjOGJlPl0gYWNwaV9ib290
X3RhYmxlX2luaXQrMHgzNy8weGY5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlNTFm
ZDg+XSBzZXR1cF9hcmNoKzB4Y2I5LzB4MTE0NgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZm
ZjgxZTRkZjkxPl0gc3RhcnRfa2VybmVsKzB4ZTgvMHg2OGIKWyAgICAwLjAwMDAwMF0gIFs8
ZmZmZmZmZmY4MWU0ZDEyMD5dID8gZWFybHlfaWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsg
ICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODFlNGQ1OWM+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2
YXRpb25zKzB4NDYvMHg0ZgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxZTRkNmYzPl0g
eDg2XzY0X3N0YXJ0X2tlcm5lbCsweDE0ZS8weDE2MgpbICAgIDAuMDAwMDAwXSAtLS1bIGVu
ZCB0cmFjZSBiZmI0ZTE3ZTlhZDJmNzI2IF0tLS0KWyAgICAwLjAwMDAwMF0ga3ZtLWNsb2Nr
OiBVc2luZyBtc3JzIDRiNTY0ZDAxIGFuZCA0YjU2NGQwMAova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWliMS0wODE4MTcxMy84OWY3Y2ExYWYxNWJkZmU3YTZhZWQzNDMwMzJhODRhZjJh
NjlmNzM2L2RtZXNnLXF1YW50YWwtaXZiNDQtNTI6MjAxNDA4MTkxODQwMzE6eDg2XzY0LXJh
bmRjb25maWctaWIxLTA4MTgxNzEzOjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pYjEt
MDgxODE3MTMvODlmN2NhMWFmMTViZGZlN2E2YWVkMzQzMDMyYTg0YWYyYTY5ZjczNi9kbWVz
Zy1xdWFudGFsLWl2YjQ0LTI6MjAxNDA4MTkxODQxMTg6eDg2XzY0LXJhbmRjb25maWctaWIx
LTA4MTgxNzEzOjoKMDoyOjcyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rp
bmc6IDIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3Rl
cCkKWzdmZWQ4NjZiNWNlNmY0NWZiMGMyMjZjNmZmODk3ZDdhZjNhMTE3NmFdIHZmczogRG9j
dW1lbnQgdGhlIGVmZmVjdCBvZiBkX3JldmFsaWRhdGUgb24gZF9maW5kX2FsaWFzCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290
LWJpc2VjdC9saW51eC00L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy9uZXh0Om1hc3Rlcjo3ZmVk
ODY2YjVjZTZmNDVmYjBjMjI2YzZmZjg5N2Q3YWYzYTExNzZhOmJpc2VjdC1saW51eC00Cgoy
MDE0LTA4LTE5IDE4OjQxOjM1IDdmZWQ4NjZiNWNlNmY0NWZiMGMyMjZjNmZmODk3ZDdhZjNh
MTE3NmEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLTdmZWQ4NjZiNWNlNmY0
NWZiMGMyMjZjNmZmODk3ZDdhZjNhMTE3NmEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy83ZmVkODY2YjVjZTZmNDVmYjBjMjI2
YzZmZjg5N2Q3YWYzYTExNzZhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMtN2ZlZDg2
NmI1Y2U2ZjQ1ZmIwYzIyNmM2ZmY4OTdkN2FmM2ExMTc2YQprZXJuZWw6IC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzLzdmZWQ4NjZiNWNlNmY0NWZiMGMyMjZjNmZm
ODk3ZDdhZjNhMTE3NmEvdm1saW51ei0zLjE2LjAtMTAyODgtZzdmZWQ4NjYKCjIwMTQtMDgt
MTkgMTg6NDQ6MzUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkyNwk0MQk0OAk2MQk2OAk3Ngk4
OAkxMDIJMTEyCTEzMAkxNDIJMTU0CTE3NQkxOTMJMjQwCTI1OAkyNzcJMzE2CTM0NgkzNjgJ
Mzg0CTQwNgk0NjkJNTA2CTUzNwk1NzUJNjMxCTc0Nwk4MTkJODk4CTkwMCBTVUNDRVNTCgpC
aXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDEgc3RlcCkKW2RlMGVkOTJhMmZiYjllYjkzYTk3ZGE3NjEyMzYzYzhjMzEzMGVjMjBdIHZm
czogRG9uJ3QgYWxsb3cgb3ZlcndyaXRpbmcgbW91bnRzIGluIHRoZSBjdXJyZW50IG1vdW50
IG5hbWVzcGFjZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNC9vYmotYmlzZWN0CmxzIC1hIC9rYnVp
bGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMv
bmV4dDptYXN0ZXI6ZGUwZWQ5MmEyZmJiOWViOTNhOTdkYTc2MTIzNjNjOGMzMTMwZWMyMDpi
aXNlY3QtbGludXgtNAoKMjAxNC0wOC0xOSAxOTowMDozOCBkZTBlZDkyYTJmYmI5ZWI5M2E5
N2RhNzYxMjM2M2M4YzMxMzBlYzIwIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcx
My1kZTBlZDkyYTJmYmI5ZWI5M2E5N2RhNzYxMjM2M2M4YzMxMzBlYzIwCkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvZGUwZWQ5
MmEyZmJiOWViOTNhOTdkYTc2MTIzNjNjOGMzMTMwZWMyMAp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaWIx
LTA4MTgxNzEzLWRlMGVkOTJhMmZiYjllYjkzYTk3ZGE3NjEyMzYzYzhjMzEzMGVjMjAKa2Vy
bmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy9kZTBlZDkyYTJm
YmI5ZWI5M2E5N2RhNzYxMjM2M2M4YzMxMzBlYzIwL3ZtbGludXotMy4xNi4wLTEwNzM4LWdk
ZTBlZDkyYQoKMjAxNC0wOC0xOSAxOTowMjozOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJNzkJ
MTEyCTE0OQkxODYJMjUyCTM4OAk0NDkJNTQ5CTY2Mgk4NTAJOTAwIFNVQ0NFU1MKCjg5Zjdj
YTFhZjE1YmRmZTdhNmFlZDM0MzAzMmE4NGFmMmE2OWY3MzYgaXMgdGhlIGZpcnN0IGJhZCBj
b21taXQKY29tbWl0IDg5ZjdjYTFhZjE1YmRmZTdhNmFlZDM0MzAzMmE4NGFmMmE2OWY3MzYK
QXV0aG9yOiBFcmljIFcuIEJpZWRlcm1hbiA8ZWJpZWRlcm1hbkB0d2l0dGVyLmNvbT4KRGF0
ZTogICBTdW4gU2VwIDIyIDE5OjM3OjAxIDIwMTMgLTA3MDAKCiAgICB2ZnM6IEtlZXAgYSBs
aXN0IG9mIG1vdW50cyBvbiBhIG1vdW50IHBvaW50CiAgICAKICAgIFRvIHNwb3QgYW55IHBv
c3NpYmxlIHByb2JsZW1zIGNhbGwgQlVHIGlmIGEgbW91bnRwb2ludAogICAgaXMgcHV0IHdo
ZW4gaXQncyBsaXN0IG9mIG1vdW50cyBpcyBub3QgZW1wdHkuCiAgICAKICAgIEFWOiB1c2Ug
aGxpc3QgaW5zdGVhZCBvZiBsaXN0X2hlYWQKICAgIAogICAgUmV2aWV3ZWQtYnk6IE1pa2xv
cyBTemVyZWRpIDxtaWtsb3NAc3plcmVkaS5odT4KICAgIFNpZ25lZC1vZmYtYnk6IEVyaWMg
Vy4gQmllZGVybWFuIDxlYmllZGVybWFuQHR3aXR0ZXIuY29tPgogICAgU2lnbmVkLW9mZi1i
eTogQWwgVmlybyA8dmlyb0B6ZW5pdi5saW51eC5vcmcudWs+Cgo6MDQwMDAwIDA0MDAwMCAw
NjU4Y2ZhYTFjYmYyNmNhODJiYmQ5OWNjNTk3YzQ1OGZmNTBlYzBiIDk1MmY2MTYxMzQ0ZGQw
YzA5Mjg3Y2ZhNzcxZmYwNDRjZTFiNTQyMTYgTQlmcwpiaXNlY3QgcnVuIHN1Y2Nlc3MKSEVB
RCBpcyBub3cgYXQgZGUwZWQ5MmEuLi4gdmZzOiBEb24ndCBhbGxvdyBvdmVyd3JpdGluZyBt
b3VudHMgaW4gdGhlIGN1cnJlbnQgbW91bnQgbmFtZXNwYWNlCmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvbmV4dDpt
YXN0ZXI6ZGUwZWQ5MmEyZmJiOWViOTNhOTdkYTc2MTIzNjNjOGMzMTMwZWMyMDpiaXNlY3Qt
bGludXgtNAoKMjAxNC0wOC0xOSAxOTowODowOSBkZTBlZDkyYTJmYmI5ZWI5M2E5N2RhNzYx
MjM2M2M4YzMxMzBlYzIwIHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4
MTgxNzEzL2RlMGVkOTJhMmZiYjllYjkzYTk3ZGE3NjEyMzYzYzhjMzEzMGVjMjAvdm1saW51
ei0zLjE2LjAtMTA3MzgtZ2RlMGVkOTJhCgoyMDE0LTA4LTE5IDE5OjA4OjEwIGRldGVjdGlu
ZyBib290IHN0YXRlIC4JMzcJMjQ0CTQ1Mgk2MzUJNzY1CTkzOAkxMDAwIFNVQ0NFU1MKClBy
ZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGRlMGVkOTJhLi4uIHZmczogRG9uJ3QgYWxsb3cg
b3ZlcndyaXRpbmcgbW91bnRzIGluIHRoZSBjdXJyZW50IG1vdW50IG5hbWVzcGFjZQpIRUFE
IGlzIG5vdyBhdCBmNjhmODIzLi4uIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZv
ciAyMDE0MDgxOApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWctaWIxLTA4MTgxNzEzL25leHQ6bWFzdGVyOmY2OGY4MjM2NDkzODU0OGI1OGI1
MWQ0YjkyNjY0MmIwYTNjZjRjMjc6YmlzZWN0LWxpbnV4LTQKIFRFU1QgRkFJTFVSRQpbICAg
IDMuNDA3MzIwXSBjdXQgKDg2KSB1c2VkIGdyZWF0ZXN0IHN0YWNrIGRlcHRoOiAxMzU2MCBi
eXRlcyBsZWZ0ClsgICAgMy40MjcxNDddIG1vdW50YWxsICg4NykgdXNlZCBncmVhdGVzdCBz
dGFjayBkZXB0aDogMTM1NTIgYnl0ZXMgbGVmdAptb3VudGFsbDogRXZlbnQgZmFpbGVkClsg
ICAgMy40ODk4NDVdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVy
IGRlcmVmZXJlbmNlIGF0IDAwMDAwMDAwMDAwMDAwMDkKWyAgICAzLjQ5MDMwOF0gSVA6IFs8
ZmZmZmZmZmY4MTFhM2ExMT5dIG1udF9zZXRfbW91bnRwb2ludCsweDhkLzB4YjEKWyAgICAz
LjQ5MDMwOF0gUEdEIGJiNjIwNjcgUFVEIGJiNzQwNjcgUE1EIDAgClsgICAgMy40OTAzMDhd
IE9vcHM6IDAwMDIgWyMxXSBERUJVR19QQUdFQUxMT0MKWyAgICAzLjQ5MDMwOF0gQ1BVOiAw
IFBJRDogOTkgQ29tbTogbW91bnQgTm90IHRhaW50ZWQgMy4xNy4wLXJjMS1uZXh0LTIwMTQw
ODE4ICMxClsgICAgMy40OTAzMDhdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9T
IEJvY2hzIDAxLzAxLzIwMTEKWyAgICAzLjQ5MDMwOF0gdGFzazogZmZmZjg4MDAwYmJjODAw
MCB0aTogZmZmZjg4MDAwYmI0YzAwMCB0YXNrLnRpOiBmZmZmODgwMDBiYjRjMDAwClsgICAg
My40OTAzMDhdIFJJUDogMDAxMDpbPGZmZmZmZmZmODExYTNhMTE+XSAgWzxmZmZmZmZmZjgx
MWEzYTExPl0gbW50X3NldF9tb3VudHBvaW50KzB4OGQvMHhiMQpbICAgIDMuNDkwMzA4XSBS
U1A6IDAwMTg6ZmZmZjg4MDAwYmI0ZmRmMCAgRUZMQUdTOiAwMDAxMDIwMgpbICAgIDMuNDkw
MzA4XSBSQVg6IDAwMDAwMDAwMDAwMDAwMDEgUkJYOiBmZmZmODgwMDBiYjgyM2U4IFJDWDog
MDAwMDAwMDAwMDAwMDIyNQpbICAgIDMuNDkwMzA4XSBSRFg6IGZmZmY4ODAwMGJiNDdmYjAg
UlNJOiAwMDAwMDAwMDAwMDAwMDA0IFJESTogZmZmZjg4MDAwYjQwNmMzMApbICAgIDMuNDkw
MzA4XSBSQlA6IGZmZmY4ODAwMGJiNGZlMTAgUjA4OiAwMDAwMDAwMDAwMDAwMDA0IFIwOTog
MDAwMWI0ODk0NDQ0ODIyNQpbICAgIDMuNDkwMzA4XSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAg
UjExOiBmZmZmZmZmZjgxZjliZjA4IFIxMjogZmZmZjg4MDAwYmI0N2VjMApbICAgIDMuNDkw
MzA4XSBSMTM6IGZmZmY4ODAwMGJhZWY3YzAgUjE0OiBmZmZmODgwMDBiNDA2YmIwIFIxNTog
MDAwMDAwMDAwMDAwMDAyMApbICAgIDMuNDkwMzA4XSBGUzogIDAwMDA3ZjAwYmZmZDk4MDAo
MDAwMCkgR1M6ZmZmZmZmZmY4MWI2ODAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAw
ClsgICAgMy40OTAzMDhdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAw
MDAwODAwNTAwMzMKWyAgICAzLjQ5MDMwOF0gQ1IyOiAwMDAwMDAwMDAwMDAwMDA5IENSMzog
MDAwMDAwMDAwYjQwNTAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2YjAKWyAgICAzLjQ5MDMwOF0g
U3RhY2s6ClsgICAgMy40OTAzMDhdICBmZmZmODgwMDBiYjQ3ZWMwIGZmZmY4ODAwMGJhZWY3
YzAgZmZmZjg4MDAwYmI4MjNlOCAwMDAwMDAwMDAwMDAwMDAwClsgICAgMy40OTAzMDhdICBm
ZmZmODgwMDBiYjRmZTU4IGZmZmZmZmZmODExYTRlYWMgZmZmZmZmZmY4MTFhNTA3ZiAwMDAw
MDAwMDAwMDAwMDAwClsgICAgMy40OTAzMDhdICBmZmZmODgwMDBiYjgyM2U4IGZmZmY4ODAw
MGJiNDdlYzAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDBiYjRmZWQwClsgICAgMy40OTAz
MDhdIENhbGwgVHJhY2U6ClsgICAgMy40OTAzMDhdICBbPGZmZmZmZmZmODExYTRlYWM+XSBh
dHRhY2hfcmVjdXJzaXZlX21udCsweDFhZi8weDMyNgpbICAgIDMuNDkwMzA4XSAgWzxmZmZm
ZmZmZjgxMWE1MDdmPl0gPyBncmFmdF90cmVlKzB4NWMvMHg3MwpbICAgIDMuNDkwMzA4XSAg
WzxmZmZmZmZmZjgxMWE1MDdmPl0gZ3JhZnRfdHJlZSsweDVjLzB4NzMKWyAgICAzLjQ5MDMw
OF0gIFs8ZmZmZmZmZmY4MTFhNTE4ZD5dIGRvX2FkZF9tb3VudCsweGY3LzB4MTFlClsgICAg
My40OTAzMDhdICBbPGZmZmZmZmZmODExYTcyZGY+XSBkb19tb3VudCsweGY1MS8weDEwMWEK
WyAgICAzLjQ5MDMwOF0gIFs8ZmZmZmZmZmY4MTE1NGM4ZD5dID8gbWlnaHRfZmF1bHQrMHg2
Zi8weGQxClsgICAgMy40OTAzMDhdICBbPGZmZmZmZmZmODExNDVlMmQ+XSA/IHN0cm5kdXBf
dXNlcisweDUxLzB4NzMKWyAgICAzLjQ5MDMwOF0gIFs8ZmZmZmZmZmY4MTFhNzZkZD5dIFN5
U19tb3VudCsweGM4LzB4MTI0ClsgICAgMy40OTAzMDhdICBbPGZmZmZmZmZmODE3MjJiNTE+
XSB0cmFjZXN5cysweGQzLzB4ZDgKWyAgICAzLjQ5MDMwOF0gQ29kZTogZjAgMDAgMDAgMDAg
NGQgODkgNmMgMjQgMTAgNDkgODkgOWMgMjQgZTggMDAgMDAgMDAgNDggOGIgNDMgMTggNDgg
ODUgYzAgNDkgODkgODQgMjQgZjAgMDAgMDAgMDAgNzUgMDkgNDggZmYgMDUgZDEgNGIgYjIg
MDEgZWIgMGIgPDQ4PiA4OSA1MCAwOCA0OCBmZiAwNSBjYyA0YiBiMiAwMSA0OCA4OSA1MyAx
OCA0OCA4MyBjMyAxOCA0OSA4OSAKWyAgICAzLjQ5MDMwOF0gUklQICBbPGZmZmZmZmZmODEx
YTNhMTE+XSBtbnRfc2V0X21vdW50cG9pbnQrMHg4ZC8weGIxClsgICAgMy40OTAzMDhdICBS
U1AgPGZmZmY4ODAwMGJiNGZkZjA+ClsgICAgMy40OTAzMDhdIENSMjogMDAwMDAwMDAwMDAw
MDAwOQpbICAgIDMuNDkwMzA4XSAtLS1bIGVuZCB0cmFjZSBmMzhjMDlhZTQxY2JjZDBjIF0t
LS0KWyAgICAzLjQ5MDMwOF0gQlVHOiBzbGVlcGluZyBmdW5jdGlvbiBjYWxsZWQgZnJvbSBp
bnZhbGlkIGNvbnRleHQgYXQga2VybmVsL2xvY2tpbmcvcndzZW0uYzo0MQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMy9mNjhmODIzNjQ5Mzg1NDhiNThiNTFkNGI5
MjY2NDJiMGEzY2Y0YzI3L2RtZXNnLXF1YW50YWwtdnAtMTg6MjAxNDA4MTkxNDQ2MTc6eDg2
XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzOjMuMTcuMC1yYzEtbmV4dC0yMDE0MDgxODox
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaWIxLTA4MTgxNzEzL2Y2OGY4MjM2NDkzODU0
OGI1OGI1MWQ0YjkyNjY0MmIwYTNjZjRjMjcvZG1lc2ctcXVhbnRhbC12cC0xODoyMDE0MDgx
ODE3MTQ1MTp4ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTM6My4xNy4wLXJjMS1uZXh0
LTIwMTQwODE4OjEKMDoyOjExIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpIRUFEIGlz
IG5vdyBhdCBmNjhmODIzIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0
MDgxOAoKPT09PT09PT09IGxpbnVzL21hc3RlciA9PT09PT09PT0KUHJldmlvdXMgSEVBRCBw
b3NpdGlvbiB3YXMgZjY4ZjgyMy4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBm
b3IgMjAxNDA4MTgKSEVBRCBpcyBub3cgYXQgN2QxMzExYi4uLiBMaW51eCAzLjE3LXJjMQps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaWIx
LTA4MTgxNzEzL2xpbnVzOm1hc3Rlcjo3ZDEzMTFiOTNlNThlZDU1ZjNhMzFjYzhmOTRjNGI4
ZmU5ODhhMmI5OmJpc2VjdC1saW51eC00CgoyMDE0LTA4LTE5IDE5OjE0OjEyIDdkMTMxMWI5
M2U1OGVkNTVmM2EzMWNjOGY5NGM0YjhmZTk4OGEyYjkgcmV1c2UgL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvN2QxMzExYjkzZTU4ZWQ1NWYzYTMxY2M4Zjk0YzRi
OGZlOTg4YTJiOS92bWxpbnV6LTMuMTcuMC1yYzEKCjIwMTQtMDgtMTkgMTk6MTQ6MTIgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLgk4MgkzNDkJNTc0CTY4Ngk4MTgJODM0CTkyNAk5OTYJMTAw
MCBTVUNDRVNTCgoKPT09PT09PT09IG5leHQvbWFzdGVyID09PT09PT09PQpQcmV2aW91cyBI
RUFEIHBvc2l0aW9uIHdhcyA3ZDEzMTFiLi4uIExpbnV4IDMuMTctcmMxCkhFQUQgaXMgbm93
IGF0IGY2OGY4MjMuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQw
ODE4CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1pYjEtMDgxODE3MTMvbmV4dDptYXN0ZXI6ZjY4ZjgyMzY0OTM4NTQ4YjU4YjUxZDRiOTI2
NjQyYjBhM2NmNGMyNzpiaXNlY3QtbGludXgtNAogVEVTVCBGQUlMVVJFClsgICAgMy40MDcz
MjBdIGN1dCAoODYpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDEzNTYwIGJ5dGVzIGxl
ZnQKWyAgICAzLjQyNzE0N10gbW91bnRhbGwgKDg3KSB1c2VkIGdyZWF0ZXN0IHN0YWNrIGRl
cHRoOiAxMzU1MiBieXRlcyBsZWZ0Cm1vdW50YWxsOiBFdmVudCBmYWlsZWQKWyAgICAzLjQ4
OTg0NV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZl
cmVuY2UgYXQgMDAwMDAwMDAwMDAwMDAwOQpbICAgIDMuNDkwMzA4XSBJUDogWzxmZmZmZmZm
ZjgxMWEzYTExPl0gbW50X3NldF9tb3VudHBvaW50KzB4OGQvMHhiMQpbICAgIDMuNDkwMzA4
XSBQR0QgYmI2MjA2NyBQVUQgYmI3NDA2NyBQTUQgMCAKWyAgICAzLjQ5MDMwOF0gT29wczog
MDAwMiBbIzFdIERFQlVHX1BBR0VBTExPQwpbICAgIDMuNDkwMzA4XSBDUFU6IDAgUElEOiA5
OSBDb21tOiBtb3VudCBOb3QgdGFpbnRlZCAzLjE3LjAtcmMxLW5leHQtMjAxNDA4MTggIzEK
WyAgICAzLjQ5MDMwOF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMg
MDEvMDEvMjAxMQpbICAgIDMuNDkwMzA4XSB0YXNrOiBmZmZmODgwMDBiYmM4MDAwIHRpOiBm
ZmZmODgwMDBiYjRjMDAwIHRhc2sudGk6IGZmZmY4ODAwMGJiNGMwMDAKWyAgICAzLjQ5MDMw
OF0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTFhM2ExMT5dICBbPGZmZmZmZmZmODExYTNhMTE+
XSBtbnRfc2V0X21vdW50cG9pbnQrMHg4ZC8weGIxClsgICAgMy40OTAzMDhdIFJTUDogMDAx
ODpmZmZmODgwMDBiYjRmZGYwICBFRkxBR1M6IDAwMDEwMjAyClsgICAgMy40OTAzMDhdIFJB
WDogMDAwMDAwMDAwMDAwMDAwMSBSQlg6IGZmZmY4ODAwMGJiODIzZTggUkNYOiAwMDAwMDAw
MDAwMDAwMjI1ClsgICAgMy40OTAzMDhdIFJEWDogZmZmZjg4MDAwYmI0N2ZiMCBSU0k6IDAw
MDAwMDAwMDAwMDAwMDQgUkRJOiBmZmZmODgwMDBiNDA2YzMwClsgICAgMy40OTAzMDhdIFJC
UDogZmZmZjg4MDAwYmI0ZmUxMCBSMDg6IDAwMDAwMDAwMDAwMDAwMDQgUjA5OiAwMDAxYjQ4
OTQ0NDQ4MjI1ClsgICAgMy40OTAzMDhdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IGZm
ZmZmZmZmODFmOWJmMDggUjEyOiBmZmZmODgwMDBiYjQ3ZWMwClsgICAgMy40OTAzMDhdIFIx
MzogZmZmZjg4MDAwYmFlZjdjMCBSMTQ6IGZmZmY4ODAwMGI0MDZiYjAgUjE1OiAwMDAwMDAw
MDAwMDAwMDIwClsgICAgMy40OTAzMDhdIEZTOiAgMDAwMDdmMDBiZmZkOTgwMCgwMDAwKSBH
UzpmZmZmZmZmZjgxYjY4MDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAz
LjQ5MDMwOF0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1
MDAzMwpbICAgIDMuNDkwMzA4XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDkgQ1IzOiAwMDAwMDAw
MDBiNDA1MDAwIENSNDogMDAwMDAwMDAwMDAwMDZiMApbICAgIDMuNDkwMzA4XSBTdGFjazoK
WyAgICAzLjQ5MDMwOF0gIGZmZmY4ODAwMGJiNDdlYzAgZmZmZjg4MDAwYmFlZjdjMCBmZmZm
ODgwMDBiYjgyM2U4IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAzLjQ5MDMwOF0gIGZmZmY4ODAw
MGJiNGZlNTggZmZmZmZmZmY4MTFhNGVhYyBmZmZmZmZmZjgxMWE1MDdmIDAwMDAwMDAwMDAw
MDAwMDAKWyAgICAzLjQ5MDMwOF0gIGZmZmY4ODAwMGJiODIzZTggZmZmZjg4MDAwYmI0N2Vj
MCAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMGJiNGZlZDAKWyAgICAzLjQ5MDMwOF0gQ2Fs
bCBUcmFjZToKWyAgICAzLjQ5MDMwOF0gIFs8ZmZmZmZmZmY4MTFhNGVhYz5dIGF0dGFjaF9y
ZWN1cnNpdmVfbW50KzB4MWFmLzB4MzI2ClsgICAgMy40OTAzMDhdICBbPGZmZmZmZmZmODEx
YTUwN2Y+XSA/IGdyYWZ0X3RyZWUrMHg1Yy8weDczClsgICAgMy40OTAzMDhdICBbPGZmZmZm
ZmZmODExYTUwN2Y+XSBncmFmdF90cmVlKzB4NWMvMHg3MwpbICAgIDMuNDkwMzA4XSAgWzxm
ZmZmZmZmZjgxMWE1MThkPl0gZG9fYWRkX21vdW50KzB4ZjcvMHgxMWUKWyAgICAzLjQ5MDMw
OF0gIFs8ZmZmZmZmZmY4MTFhNzJkZj5dIGRvX21vdW50KzB4ZjUxLzB4MTAxYQpbICAgIDMu
NDkwMzA4XSAgWzxmZmZmZmZmZjgxMTU0YzhkPl0gPyBtaWdodF9mYXVsdCsweDZmLzB4ZDEK
WyAgICAzLjQ5MDMwOF0gIFs8ZmZmZmZmZmY4MTE0NWUyZD5dID8gc3RybmR1cF91c2VyKzB4
NTEvMHg3MwpbICAgIDMuNDkwMzA4XSAgWzxmZmZmZmZmZjgxMWE3NmRkPl0gU3lTX21vdW50
KzB4YzgvMHgxMjQKWyAgICAzLjQ5MDMwOF0gIFs8ZmZmZmZmZmY4MTcyMmI1MT5dIHRyYWNl
c3lzKzB4ZDMvMHhkOApbICAgIDMuNDkwMzA4XSBDb2RlOiBmMCAwMCAwMCAwMCA0ZCA4OSA2
YyAyNCAxMCA0OSA4OSA5YyAyNCBlOCAwMCAwMCAwMCA0OCA4YiA0MyAxOCA0OCA4NSBjMCA0
OSA4OSA4NCAyNCBmMCAwMCAwMCAwMCA3NSAwOSA0OCBmZiAwNSBkMSA0YiBiMiAwMSBlYiAw
YiA8NDg+IDg5IDUwIDA4IDQ4IGZmIDA1IGNjIDRiIGIyIDAxIDQ4IDg5IDUzIDE4IDQ4IDgz
IGMzIDE4IDQ5IDg5IApbICAgIDMuNDkwMzA4XSBSSVAgIFs8ZmZmZmZmZmY4MTFhM2ExMT5d
IG1udF9zZXRfbW91bnRwb2ludCsweDhkLzB4YjEKWyAgICAzLjQ5MDMwOF0gIFJTUCA8ZmZm
Zjg4MDAwYmI0ZmRmMD4KWyAgICAzLjQ5MDMwOF0gQ1IyOiAwMDAwMDAwMDAwMDAwMDA5Clsg
ICAgMy40OTAzMDhdIC0tLVsgZW5kIHRyYWNlIGYzOGMwOWFlNDFjYmNkMGMgXS0tLQpbICAg
IDMuNDkwMzA4XSBCVUc6IHNsZWVwaW5nIGZ1bmN0aW9uIGNhbGxlZCBmcm9tIGludmFsaWQg
Y29udGV4dCBhdCBrZXJuZWwvbG9ja2luZy9yd3NlbS5jOjQxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaWIxLTA4MTgxNzEzL2Y2OGY4MjM2NDkzODU0OGI1OGI1MWQ0YjkyNjY0MmIw
YTNjZjRjMjcvZG1lc2ctcXVhbnRhbC12cC0xODoyMDE0MDgxOTE0NDYxNzp4ODZfNjQtcmFu
ZGNvbmZpZy1pYjEtMDgxODE3MTM6My4xNy4wLXJjMS1uZXh0LTIwMTQwODE4OjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1pYjEtMDgxODE3MTMvZjY4ZjgyMzY0OTM4NTQ4YjU4YjUx
ZDRiOTI2NjQyYjBhM2NmNGMyNy9kbWVzZy1xdWFudGFsLXZwLTE4OjIwMTQwODE4MTcxNDUx
Ong4Nl82NC1yYW5kY29uZmlnLWliMS0wODE4MTcxMzozLjE3LjAtcmMxLW5leHQtMjAxNDA4
MTg6MQowOjI6MTEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCg==

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.16.0-10291-g89f7ca1"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.16.0 Kernel Configuration
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
CONFIG_CONSTRUCTORS=y
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
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_FHANDLE is not set
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
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
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_FORCE=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
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
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
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
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
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
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_X86_16BIT is not set
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
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
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_KEXEC_VERIFY_SIG is not set
CONFIG_CRASH_DUMP=y
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
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
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
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
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
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=y
CONFIG_PMC_ATOM=y
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
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

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
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_FENCE_TRACE=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=y

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
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_GPIO_ADDR is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0

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
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH is not set
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
# CONFIG_GENWQE is not set
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

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
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
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
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
CONFIG_INPUT_88PM80X_ONKEY=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_GP2A is not set
CONFIG_INPUT_GPIO_BEEPER=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_RETU_PWRBUTTON is not set
# CONFIG_INPUT_TWL4030_PWRBUTTON is not set
CONFIG_INPUT_TWL4030_VIBRA=y
# CONFIG_INPUT_TWL6040_VIBRA is not set
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
# CONFIG_INPUT_DA9052_ONKEY is not set
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_I2C is not set
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
CONFIG_INPUT_IDEAPAD_SLIDEBAR=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
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
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
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
# CONFIG_SERIAL_SC16IS7XX is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_SERIAL_MEN_Z135=y
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_SI_PROBE_DEFAULTS is not set
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y

#
# I2C support
#
CONFIG_I2C=y
CONFIG_I2C_ACPI=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

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
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

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
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
# CONFIG_PPS_CLIENT_GPIO is not set

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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
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
# CONFIG_GPIO_LP3943 is not set
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TWL4030=y
# CONFIG_GPIO_TWL6040 is not set
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

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
CONFIG_GPIO_PALMAS=y
# CONFIG_GPIO_TPS65910 is not set

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2406=y
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MAX8997 is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_POWR1220=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_NCT6683=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_TPS40422=y
CONFIG_SENSORS_UCD9000=y
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SHTC1=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM8350=y

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
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_ACPI_INT3403_THERMAL is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_DA9052_WATCHDOG is not set
CONFIG_WM8350_WATCHDOG=y
CONFIG_XILINX_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=y
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_CPU5_WDT=y
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
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
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
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
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
# CONFIG_MFD_AXP20X is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_INTEL_SOC_PMIC is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_AAT2870=y
# CONFIG_REGULATOR_AS3711 is not set
# CONFIG_REGULATOR_BCM590XX is not set
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9063=y
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_DA9211 is not set
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_LP8788 is not set
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_S2MPA01=y
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=y
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65910=y
# CONFIG_REGULATOR_TPS80031 is not set
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_DVB_CORE=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=y
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_SI470X=y
# CONFIG_I2C_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_RADIO_MAXIRADIO is not set
CONFIG_RADIO_TEA5764=y
CONFIG_RADIO_TEA5764_XTAL=y
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=y
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_SMS_SIANO_MDTV=y

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
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
CONFIG_VIDEO_TLV320AIC23B=y
CONFIG_VIDEO_UDA1342=y
CONFIG_VIDEO_WM8775=y
# CONFIG_VIDEO_WM8739 is not set
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
CONFIG_VIDEO_BT819=y
# CONFIG_VIDEO_BT856 is not set
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
# CONFIG_VIDEO_ML86V7667 is not set
CONFIG_VIDEO_SAA7110=y
# CONFIG_VIDEO_SAA711X is not set
CONFIG_VIDEO_SAA7191=y
CONFIG_VIDEO_TVP514X=y
# CONFIG_VIDEO_TVP5150 is not set
CONFIG_VIDEO_TVP7002=y
CONFIG_VIDEO_TW2804=y
# CONFIG_VIDEO_TW9903 is not set
CONFIG_VIDEO_TW9906=y
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
CONFIG_VIDEO_ADV7175=y
# CONFIG_VIDEO_ADV7343 is not set
CONFIG_VIDEO_ADV7393=y
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=y
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=y
# CONFIG_MEDIA_TUNER_TDA18271 is not set
CONFIG_MEDIA_TUNER_TDA9887=y
# CONFIG_MEDIA_TUNER_TEA5761 is not set
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=y
# CONFIG_MEDIA_TUNER_XC2028 is not set
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_XC4000=y
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
# CONFIG_MEDIA_TUNER_MAX2165 is not set
# CONFIG_MEDIA_TUNER_TDA18218 is not set
CONFIG_MEDIA_TUNER_FC0011=y
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=y
# CONFIG_MEDIA_TUNER_TDA18212 is not set
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_M88TS2022=y
CONFIG_MEDIA_TUNER_TUA9001=y
# CONFIG_MEDIA_TUNER_SI2157 is not set
CONFIG_MEDIA_TUNER_IT913X=y
CONFIG_MEDIA_TUNER_R820T=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV6110x=y

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
# CONFIG_DVB_TDA18271C2DD is not set
CONFIG_DVB_SI2165=y

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
# CONFIG_DVB_CX24123 is not set
CONFIG_DVB_MT312=y
# CONFIG_DVB_ZL10036 is not set
# CONFIG_DVB_ZL10039 is not set
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
# CONFIG_DVB_STV0299 is not set
# CONFIG_DVB_STV6110 is not set
CONFIG_DVB_STV0900=y
CONFIG_DVB_TDA8083=y
# CONFIG_DVB_TDA10086 is not set
# CONFIG_DVB_TDA8261 is not set
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
# CONFIG_DVB_TUA6100 is not set
# CONFIG_DVB_CX24116 is not set
# CONFIG_DVB_CX24117 is not set
# CONFIG_DVB_SI21XX is not set
# CONFIG_DVB_TS2020 is not set
# CONFIG_DVB_DS3000 is not set
# CONFIG_DVB_MB86A16 is not set
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
# CONFIG_DVB_SP887X is not set
CONFIG_DVB_CX22700=y
# CONFIG_DVB_CX22702 is not set
# CONFIG_DVB_S5H1432 is not set
CONFIG_DVB_DRXD=y
# CONFIG_DVB_L64781 is not set
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_NXT6000=y
# CONFIG_DVB_MT352 is not set
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
CONFIG_DVB_DIB3000MC=y
CONFIG_DVB_DIB7000M=y
CONFIG_DVB_DIB7000P=y
CONFIG_DVB_DIB9000=y
CONFIG_DVB_TDA10048=y
# CONFIG_DVB_AF9013 is not set
CONFIG_DVB_EC100=y
CONFIG_DVB_HD29L2=y
# CONFIG_DVB_STV0367 is not set
CONFIG_DVB_CXD2820R=y
CONFIG_DVB_RTL2830=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10021=y
# CONFIG_DVB_TDA10023 is not set
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
# CONFIG_DVB_OR51211 is not set
CONFIG_DVB_OR51132=y
CONFIG_DVB_BCM3510=y
CONFIG_DVB_LGDT330X=y
# CONFIG_DVB_LGDT3305 is not set
CONFIG_DVB_LG2160=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_DTV=y
CONFIG_DVB_AU8522_V4L=y
# CONFIG_DVB_S5H1411 is not set

#
# ISDB-T (terrestrial) frontends
#
# CONFIG_DVB_S921 is not set
CONFIG_DVB_DIB8000=y
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#
# CONFIG_DVB_PLL is not set
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=y
CONFIG_DVB_LNBP21=y
# CONFIG_DVB_LNBP22 is not set
CONFIG_DVB_ISL6405=y
# CONFIG_DVB_ISL6421 is not set
CONFIG_DVB_ISL6423=y
CONFIG_DVB_A8293=y
CONFIG_DVB_LGS8GL5=y
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
# CONFIG_DVB_TDA665x is not set
CONFIG_DVB_IX2505V=y
CONFIG_DVB_M88RS2000=y
CONFIG_DVB_AF9033=y

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
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_PTN3460=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
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
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
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
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=y
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
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_AAT2870=y
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_AS3711=y
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO=y
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
# CONFIG_HID_PICOLCD_LCD is not set
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_RMI is not set
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
CONFIG_I2C_HID=y
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
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_USDHI6ROL0=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_LP8788 is not set
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_WM8350 is not set
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
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
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
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
CONFIG_BMA180=y
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
# CONFIG_MMA8452 is not set
CONFIG_KXCJK1013=y

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
# CONFIG_AD799X is not set
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1363=y
CONFIG_MCP3422=y
CONFIG_MEN_Z188_ADC=y
CONFIG_NAU7802=y
# CONFIG_TI_ADC081C is not set
# CONFIG_TWL4030_MADC is not set
CONFIG_TWL6030_GPADC=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5380=y
CONFIG_AD5446=y
CONFIG_MAX517=y
# CONFIG_MCP4725 is not set

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
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
CONFIG_DHT11=y
CONFIG_SI7005=y

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_APDS9300=y
# CONFIG_CM32181 is not set
# CONFIG_CM36651 is not set
CONFIG_GP2AP020A00F=y
CONFIG_ISL29125=y
# CONFIG_LTR501 is not set
CONFIG_TCS3414=y
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_AK09911=y
CONFIG_MAG3110=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_MPL115=y
CONFIG_MPL3115=y
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_T5403=y

#
# Lightning sensors
#

#
# Temperature sensors
#
# CONFIG_MLX90614 is not set
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
# CONFIG_FMC_TRIVIAL is not set
# CONFIG_FMC_WRITE_EEPROM is not set
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_ST_SPEAR1310_MIPHY=y
CONFIG_PHY_ST_SPEAR1340_MIPHY=y
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set
# CONFIG_THUNDERBOLT is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
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
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_FILE_LOCKING is not set
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_JFFS2_FS is not set
CONFIG_UBIFS_FS=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
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
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_VMACACHE=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
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
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_FIRMWARE is not set
CONFIG_TEST_UDELAY=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
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
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
# CONFIG_CRYPTO_HMAC is not set
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

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
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

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
CONFIG_CRYPTO_DRBG_MENU=y
# CONFIG_CRYPTO_DRBG_HMAC is not set
# CONFIG_CRYPTO_DRBG_HASH is not set
# CONFIG_CRYPTO_DRBG_CTR is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
# CONFIG_LIBCRC32C is not set
# CONFIG_CRC8 is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_ARCH_HAS_SG_CHAIN=y

--gBBFr7Ir9EOA20Yy--
