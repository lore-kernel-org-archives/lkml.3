Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaACTQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 14:16:16 -0500
Received: from mailout10.t-online.de ([194.25.134.21]:46536 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaACTQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 14:16:14 -0500
Message-ID: <52C70C75.4050502@t-online.de>
Date: Fri, 03 Jan 2014 20:16:05 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        reiserfs-devel@vger.kernel.org
Subject: [BUG 3.13.0-rc6] reiserfs  possible circular locking dependency
Content-Type: multipart/mixed;
 boundary="------------050405000601000804070904"
X-ID: V+oVlwZbghIBeeAX+WKIY+cfxpHHKWyZo7PiRqd42SzZPc7A6BK2oGrtnkcHWDCwrR
X-TOI-MSGID: a47160a7-6560-4652-a6bf-3cf26d7a1b64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050405000601000804070904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Rebooting after a power failure on an openSuSE 13.1 system
with kernel 3.13.0-rc6 triggered the attached lockdep warning.

cu,
  Knut


--------------050405000601000804070904
Content-Type: text/plain; charset=UTF-8;
 name="lockdep_reiser"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lockdep_reiser"

[   73.385211] REISERFS (device sdb4): checking transaction log (sdb4)
[   73.465261] REISERFS (device sdb4): Using r5 hash to sort names
[   73.533218] REISERFS (device sdb4): Removing [6064555 6678878 0x0 SD]..done
[   73.544815] REISERFS (device sdb4): Removing [6064555 6670892 0x0 SD]..done
[   73.554927] REISERFS (device sdb4): Removing [6064555 6657593 0x0 SD]..done
[   73.564808] REISERFS (device sdb4): Removing [6064555 6646126 0x0 SD]..done
[   73.582072] REISERFS (device sdb4): Removing [784966 6632977 0x0 SD]..done
[   73.597909] REISERFS (device sdb4): There were 5 uncompleted unlinks/truncates. Completed
[   73.636043] 
[   73.639788] ======================================================
[   73.639788] [ INFO: possible circular locking dependency detected ]
[   73.639788] 3.13.0-rc6-main #95 Not tainted
[   73.639788] -------------------------------------------------------
[   73.639788] systemd/1 is trying to acquire lock:
[   73.639788]  (&sbi->lock){+.+.+.}, at: [<c024b8a9>] reiserfs_write_lock+0x25/0x2f
[   73.639788] 
[   73.639788] but task is already holding lock:
[   73.639788]  (&type->i_mutex_dir_key#3/3){+.+.+.}, at: [<c024a9e1>] open_xa_dir+0xe6/0x153
[   73.639788] 
[   73.639788] which lock already depends on the new lock.
[   73.639788] 
[   73.639788] 
[   73.639788] the existing dependency chain (in reverse order) is:
[   73.639788] 
[   73.639788] -> #1 (&type->i_mutex_dir_key#3/3){+.+.+.}:
[   73.639788]        [<c0155767>] lock_acquire+0x72/0xc9
[   73.639788]        [<c054c2dc>] mutex_lock_nested+0x3a/0x27b
[   73.639788]        [<c024a937>] open_xa_dir+0x3c/0x153
[   73.639788]        [<c024aa99>] reiserfs_for_each_xattr+0x4b/0x1df
[   73.639788]        [<c024ad0f>] reiserfs_delete_xattrs+0x18/0x42
[   73.639788]        [<c0232d52>] reiserfs_evict_inode+0x84/0x138
[   73.639788]        [<c01eda6b>] evict+0x94/0x139
[   73.639788]        [<c01ee0cc>] iput+0x107/0x10d
[   73.639788]        [<c023c25c>] finish_unfinished+0x412/0x4e7
[   73.639788]        [<c023cbe3>] reiserfs_fill_super+0x8b2/0x9c6
[   73.639788]        [<c01dbeda>] mount_bdev+0x112/0x15a
[   73.639788]        [<c023a11a>] get_super_block+0x15/0x17
[   73.639788]        [<c01dc820>] mount_fs+0x5a/0x132
[   73.639788]        [<c01f096d>] vfs_kern_mount+0x4d/0xfb
[   73.639788]        [<c01f2d6e>] do_mount+0x732/0x87f
[   73.639788]        [<c01f308b>] SyS_mount+0x76/0xa5
[   73.639788]        [<c0554334>] sysenter_do_call+0x12/0x32
[   73.639788] 
[   73.639788] -> #0 (&sbi->lock){+.+.+.}:
[   73.639788]        [<c0154c6f>] __lock_acquire+0xff7/0x1556
[   73.639788]        [<c0155767>] lock_acquire+0x72/0xc9
[   73.639788]        [<c054c2dc>] mutex_lock_nested+0x3a/0x27b
[   73.639788]        [<c024b8a9>] reiserfs_write_lock+0x25/0x2f
[   73.639788]        [<c02306ef>] reiserfs_lookup+0x4a/0xea
[   73.639788]        [<c01e0ad8>] lookup_real+0x25/0x38
[   73.639788]        [<c01e14cd>] __lookup_hash+0x2f/0x36
[   73.639788]        [<c01e3df3>] lookup_one_len+0xb7/0xc6
[   73.639788]        [<c024a9f3>] open_xa_dir+0xf8/0x153
[   73.639788]        [<c024ac43>] xattr_lookup+0x16/0xca
[   73.639788]        [<c024b20a>] reiserfs_xattr_get+0x36/0x20e
[   73.639788]        [<c024c301>] reiserfs_get_acl+0x8c/0x2c1
[   73.639788]        [<c01e18f6>] generic_permission+0xba/0x1d9
[   73.639788]        [<c024b62c>] reiserfs_permission+0x13/0x19
[   73.639788]        [<c01e205a>] __inode_permission+0x30/0x70
[   73.639788]        [<c01e20de>] inode_permission+0x44/0x47
[   73.639788]        [<c01e2128>] link_path_walk+0x47/0x5cc
[   73.639788]        [<c01e31cd>] path_lookupat+0x4d/0x572
[   73.639788]        [<c01e3716>] filename_lookup+0x24/0x8b
[   73.639788]        [<c01e37ad>] do_path_lookup+0x30/0x38
[   73.639788]        [<c01e3859>] kern_path_create+0x22/0xe9
[   73.639788]        [<c01e394f>] user_path_create+0x2f/0x42
[   73.639788]        [<c01e5c88>] SyS_mkdirat+0x32/0xb3
[   73.639788]        [<c01e5d20>] SyS_mkdir+0x17/0x19
[   73.639788]        [<c0554334>] sysenter_do_call+0x12/0x32
[   73.639788] 
[   73.639788] other info that might help us debug this:
[   73.639788] 
[   73.639788]  Possible unsafe locking scenario:
[   73.639788] 
[   73.639788]        CPU0                    CPU1
[   73.639788]        ----                    ----
[   73.639788]   lock(&type->i_mutex_dir_key#3/3);
[   73.639788]                                lock(&sbi->lock);
[   73.639788]                                lock(&type->i_mutex_dir_key#3/3);
[   73.639788]   lock(&sbi->lock);
[   73.639788] 
[   73.639788]  *** DEADLOCK ***
[   73.639788] 
[   73.639788] 1 lock held by systemd/1:
[   73.639788]  #0:  (&type->i_mutex_dir_key#3/3){+.+.+.}, at: [<c024a9e1>] open_xa_dir+0xe6/0x153
[   73.639788] 
[   73.639788] stack backtrace:
[   73.639788] CPU: 0 PID: 1 Comm: systemd Not tainted 3.13.0-rc6-main #95
[   73.639788] Hardware name:    /i915GMm-HFS, BIOS 6.00 PG 09/14/2005
[   73.639788]  00000000 c0ad4cd4 f6079afc c054945c f6079b2c c054729a c06d1d61 c06d1c60
[   73.639788]  c06d1c28 c06d1c49 c06d1c28 f6079b60 f606a010 f606a474 00000001 f606a48c
[   73.639788]  f6079b90 c0154c6f f606a474 00005218 00000001 00000000 f606a474 00000001
[   73.639788] Call Trace:
[   73.639788]  [<c054945c>] dump_stack+0x16/0x18
[   73.639788]  [<c054729a>] print_circular_bug+0x22d/0x23a
[   73.639788]  [<c0154c6f>] __lock_acquire+0xff7/0x1556
[   73.639788]  [<c0155767>] lock_acquire+0x72/0xc9
[   73.639788]  [<c024b8a9>] ? reiserfs_write_lock+0x25/0x2f
[   73.639788]  [<c024b8a9>] ? reiserfs_write_lock+0x25/0x2f
[   73.639788]  [<c054c2dc>] mutex_lock_nested+0x3a/0x27b
[   73.639788]  [<c024b8a9>] ? reiserfs_write_lock+0x25/0x2f
[   73.639788]  [<c0154cb7>] ? __lock_acquire+0x103f/0x1556
[   73.639788]  [<c024b8a9>] reiserfs_write_lock+0x25/0x2f
[   73.639788]  [<c02306ef>] reiserfs_lookup+0x4a/0xea
[   73.639788]  [<c054e820>] ? _raw_spin_unlock+0x2c/0x3d
[   73.639788]  [<c0551bf8>] ? preempt_count_sub+0xa8/0xb5
[   73.639788]  [<c054e820>] ? _raw_spin_unlock+0x2c/0x3d
[   73.639788]  [<c01eb71b>] ? d_alloc+0x5c/0x63
[   73.639788]  [<c01e0ad8>] lookup_real+0x25/0x38
[   73.639788]  [<c01e14cd>] __lookup_hash+0x2f/0x36
[   73.639788]  [<c01e3df3>] lookup_one_len+0xb7/0xc6
[   73.639788]  [<c024a9f3>] open_xa_dir+0xf8/0x153
[   73.639788]  [<c0154662>] ? __lock_acquire+0x9ea/0x1556
[   73.639788]  [<c024ac43>] xattr_lookup+0x16/0xca
[   73.639788]  [<c024b20a>] reiserfs_xattr_get+0x36/0x20e
[   73.639788]  [<c054e820>] ? _raw_spin_unlock+0x2c/0x3d
[   73.639788]  [<c0551bf8>] ? preempt_count_sub+0xa8/0xb5
[   73.639788]  [<c024c301>] reiserfs_get_acl+0x8c/0x2c1
[   73.639788]  [<c01e18c9>] ? generic_permission+0x8d/0x1d9
[   73.639788]  [<c054e820>] ? _raw_spin_unlock+0x2c/0x3d
[   73.639788]  [<c0551bf8>] ? preempt_count_sub+0xa8/0xb5
[   73.639788]  [<c01e18f6>] generic_permission+0xba/0x1d9
[   73.639788]  [<c024b62c>] reiserfs_permission+0x13/0x19
[   73.639788]  [<c01e205a>] __inode_permission+0x30/0x70
[   73.639788]  [<c01e20de>] inode_permission+0x44/0x47
[   73.639788]  [<c01e2128>] link_path_walk+0x47/0x5cc
[   73.639788]  [<c0153a88>] ? trace_hardirqs_on+0xb/0xd
[   73.639788]  [<c01e31cd>] path_lookupat+0x4d/0x572
[   73.639788]  [<c01558eb>] ? lock_release_non_nested+0x12d/0x24f
[   73.639788]  [<c01c3434>] ? might_fault+0x31/0x6b
[   73.639788]  [<c01e3716>] filename_lookup+0x24/0x8b
[   73.639788]  [<c01e37ad>] do_path_lookup+0x30/0x38
[   73.639788]  [<c01e3859>] kern_path_create+0x22/0xe9
[   73.639788]  [<c01e1f61>] ? getname_flags+0x99/0x124
[   73.639788]  [<c01e394f>] user_path_create+0x2f/0x42
[   73.639788]  [<c01e5c88>] SyS_mkdirat+0x32/0xb3
[   73.639788]  [<c0554363>] ? sysenter_exit+0xf/0x16
[   73.639788]  [<c01e5d20>] SyS_mkdir+0x17/0x19
[   73.639788]  [<c0554334>] sysenter_do_call+0x12/0x32
[   74.530517] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: discard,errors=remount-ro
[   75.128158] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   75.195428] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   75.209902] ip_tables: (C) 2000-2006 Netfilter Core Team

--------------050405000601000804070904--
