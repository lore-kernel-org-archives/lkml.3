Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbaIZUxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:53:16 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:38857 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaIZUxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:53:15 -0400
MIME-Version: 1.0
Date: Fri, 26 Sep 2014 13:53:14 -0700
Message-ID: <CAKx2Y1mdiMFTBWCvGUk0mvi4oY=mFU=C-RqzKwRwxvm-5WrBOg@mail.gmail.com>
Subject: btrfs kernel trace: btrfs_delayed_qgroup_accounting
From: Kui Zhang <kuizhang@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We have been getting some of these in dmesg:

[33957.472633] ------------[ cut here ]------------
[33957.472681] WARNING: CPU: 1 PID: 22758 at fs/btrfs/qgroup.c:1408
btrfs_delayed_qgroup_accounting+0x540/0xe40()
[33957.472738] Modules linked in: cpuid nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack serio_raw microcode
[33957.472821] CPU: 1 PID: 22758 Comm: btrfs-cleaner Tainted: G
W I    3.17.0-rc6-backup5001-00216-g02f130a #5
[33957.472878] Hardware name: empty empty/S5393, BIOS V1.05 04/24/2009
[33957.472915]  0000000000000009 ffff880004a1fbf8 ffffffff817dd481
0000000000000000
[33957.472973]  0000000000000000 ffff880004a1fc38 ffffffff81084de7
ffff88010c5b4d18
[33957.473031]  ffff88017939b658 ffff8801cacdd000 ffff880301baaee0
ffff8800bad15688
[33957.473090] Call Trace:
[33957.473120]  [<ffffffff817dd481>] dump_stack+0x46/0x58
[33957.473153]  [<ffffffff81084de7>] warn_slowpath_common+0x87/0xb0
[33957.473186]  [<ffffffff81084e25>] warn_slowpath_null+0x15/0x20
[33957.473219]  [<ffffffff814026c0>] btrfs_delayed_qgroup_accounting+0x540/0xe40
[33957.473256]  [<ffffffff8138fae8>] btrfs_run_delayed_refs+0x1f8/0x280
[33957.473324]  [<ffffffff8139fcac>] btrfs_should_end_transaction+0x4c/0x70
[33957.473361]  [<ffffffff8138e15a>] btrfs_drop_snapshot+0x41a/0x7f0
[33957.473397]  [<ffffffff813f4db6>] ? btrfs_kill_all_delayed_nodes+0x56/0xf0
[33957.473433]  [<ffffffff813a1852>] btrfs_clean_one_deleted_snapshot+0xb2/0x100
[33957.473469]  [<ffffffff81398210>] cleaner_kthread+0x100/0x130
[33957.473502]  [<ffffffff81398110>] ? btrfs_alloc_root+0x40/0x40
[33957.473544]  [<ffffffff8109eb24>] kthread+0xc4/0xe0
[33957.473575]  [<ffffffff8109ea60>] ? __kthread_parkme+0x80/0x80
[33957.473609]  [<ffffffff817e37ac>] ret_from_fork+0x7c/0xb0
[33957.473645]  [<ffffffff8109ea60>] ? __kthread_parkme+0x80/0x80
[33957.473681] ---[ end trace 2b8dc3f1ba7ad88b ]---


This seems to indicate a firmware issue, how do I tell which firmware?
[33957.472821] CPU: 1 PID: 22758 Comm: btrfs-cleaner Tainted: G        W I

cat /proc/sys/kernel/tainted
2048

Thanks
Kui.Z
