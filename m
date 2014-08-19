Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaHSLj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:39:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:38195 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaHSLj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:39:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,893,1400050800"; 
   d="scan'208";a="578697016"
Date: Tue, 19 Aug 2014 19:40:03 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Eric W. Biederman" <ebiederman@twitter.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKP <lkp@01.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [vfs mnt_set_mountpoint] BUG: unable to handle kernel paging request
 at 5a5a5a5e
Message-ID: <20140819114003.GA18960@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

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
| boot_successes                                                              | 40         | 0          | 0             |
| boot_failures                                                               | 40         | 20         | 11            |
| BUG:kernel_boot_hang                                                        | 39         |            |               |
| BUG:kernel_boot_crashed                                                     | 1          |            |               |
| BUG:unable_to_handle_kernel_paging_request                                  | 0          | 20         | 11            |
| Oops                                                                        | 0          | 20         | 11            |
| EIP_is_at_mnt_set_mountpoint                                                | 0          | 20         | 11            |
| BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/rwsem.c | 0          | 20         | 11            |
| INFO:lockdep_is_turned_off                                                  | 0          | 20         | 11            |
| Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=                   | 0          | 14         | 10            |
| backtrace:do_mount                                                          | 0          | 20         | 11            |
| backtrace:SyS_mount                                                         | 0          | 20         | 11            |
+-----------------------------------------------------------------------------+------------+------------+---------------+

[   12.976559] Key type encrypted registered
[   12.979538] rtc_cmos 00:00: setting system clock to 2014-08-19 16:00:57 UTC (1408464057)
[   12.981664] debug: unmapping init [mem 0x7aff4000-0x7b220fff]
[   12.986791] BUG: unable to handle kernel paging request at 5a5a5a5e
[   12.987028] IP: [<7922d346>] mnt_set_mountpoint+0x76/0x90
[   12.987028] *pde = 00000000 
[   12.987028] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[   12.987028] CPU: 0 PID: 1 Comm: init Not tainted 3.16.0-10739-g89f7ca1 #1
[   12.987028] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   12.987028] task: 87cc1320 ti: 87cc4000 task.ti: 87cc4000
[   12.987028] EIP: 0060:[<7922d346>] EFLAGS: 00010202 CPU: 0
[   12.987028] EIP is at mnt_set_mountpoint+0x76/0x90
[   12.987028] EAX: 00000001 EBX: 5a5a5a5a ECX: 87c93700 EDX: 7cc308a0
[   12.987028] ESI: 87c93778 EDI: 00000001 EBP: 87cc5ebc ESP: 87cc5ea8
[   12.987028]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   12.987028] CR0: 80050033 CR2: 5a5a5a5e CR3: 04c51000 CR4: 00040690
[   12.987028] Stack:
[   12.987028]  87c93700 7cc308a0 87c93700 87c93b80 00000001 87cc5eec 7922eb3c 00000000
[   12.987028]  00000001 00000000 7922eca4 00000001 7cc308a0 00000000 00004000 00000000
[   12.987028]  00000001 87cc5f08 7922eca4 00000000 87c93b80 00000000 7cc308a0 87c93700
[   12.987028] Call Trace:
[   12.987028]  [<7922eb3c>] attach_recursive_mnt+0x1cc/0x2b0
[   12.987028]  [<7922eca4>] ? graft_tree+0x84/0xa0
[   12.987028]  [<7922eca4>] graft_tree+0x84/0xa0
[   12.987028]  [<7922ede3>] do_add_mount+0x123/0x190
[   12.987028]  [<79230b64>] do_mount+0xfb4/0x12f0
[   12.987028]  [<7922fb84>] ? copy_mount_string+0x54/0x80
[   12.987028]  [<79231301>] SyS_mount+0xf1/0x120
[   12.987028]  [<7a2b26f7>] syscall_call+0x7/0x7
[   12.987028] Code: 31 c0 89 59 08 8d 71 78 89 51 74 8b 5a 0c 85 db 0f 95 c0 8b 3c 85 ac 38 c8 7a 89 59 78 83 c7 01 85 c0 89 3c 85 ac 38 c8 7a 74 03 <89> 73 04 89 72 0c 83 c2 0c 89 51 7c 83 c4 08 5b 5e 5f 5d c3 8d
[   12.987028] EIP: [<7922d346>] mnt_set_mountpoint+0x76/0x90 SS:ESP 0068:87cc5ea8
[   12.987028] CR2: 000000005a5a5a5e
[   12.987028] ---[ end trace ee8b0a2eb2e91b64 ]---
[   12.987028] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:41

git bisect start f68f82364938548b58b51d4b926642b0a3cf4c27 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9 --
git bisect  bad 473f9639819684765e78d298f192b8030fe1290c  # 15:02      0-      9  Merge remote-tracking branch 'block/for-next'
git bisect good 9a9d24bbcb7185700286b300e1db132a481d0e1f  # 15:07     20+      1  Merge remote-tracking branch 'tile/master'
git bisect  bad c0698b7d9847e0cbc46881368ec9c72474968ad8  # 15:10      0-     20  Merge remote-tracking branch 'hid/for-next'
git bisect good f55058463a57a59e8b5a59f8b4ae1875c7a91a44  # 15:14     20+      9  Merge remote-tracking branch 'fscache/fscache'
git bisect good 76bb1241bec5f597b025b997d6ae7e193dab8289  # 15:26     20+      6  Merge remote-tracking branch 'logfs/master'
git bisect  bad 9016ceb4b3699bc95ffaeed371e5fd0745bab224  # 15:48      0-     20  Merge remote-tracking branch 'vfs/for-next'
git bisect  bad 76a8a45241be2aff38944e74811e23d1024a71fa  # 15:59      0-      1  vfs: Make d_invalidate return void
git bisect  bad 89f7ca1af15bdfe7a6aed343032a84af2a69f736  # 16:03      0-     18  vfs: Keep a list of mounts on a mount point
git bisect good 7fed866b5ce6f45fb0c226c6ff897d7af3a1176a  # 16:11     20+      4  vfs: Document the effect of d_revalidate on d_find_alias
git bisect good de0ed92a2fbb9eb93a97da7612363c8c3130ec20  # 16:26     20+     13  vfs: Don't allow overwriting mounts in the current mount namespace
# first bad commit: [89f7ca1af15bdfe7a6aed343032a84af2a69f736] vfs: Keep a list of mounts on a mount point
git bisect good de0ed92a2fbb9eb93a97da7612363c8c3130ec20  # 16:39     60+     40  vfs: Don't allow overwriting mounts in the current mount namespace
git bisect  bad f68f82364938548b58b51d4b926642b0a3cf4c27  # 16:39      0-     11  Add linux-next specific files for 20140818
git bisect good 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9  # 16:44     60+     16  Linux 3.17-rc1
git bisect  bad f68f82364938548b58b51d4b926642b0a3cf4c27  # 16:44      0-     11  Add linux-next specific files for 20140818


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-i386.cgz

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
