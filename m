Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab3LTDFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 22:05:04 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58009 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3LTDFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 22:05:02 -0500
Message-ID: <1387508698.10796.4.camel@phoenix>
Subject: BUG: bad unlock balance detected! (__sigqueue_alloc)
From: Axel Lin <axel.lin@ingics.com>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Fri, 20 Dec 2013 11:04:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I got below hangup with current Linus' tree.

[  166.378906] ------------[ cut here ]------------
[  166.385742] WARNING: CPU: 0 PID: 0 at kernel/rcu/update.c:107 __rcu_read_unlock+0x70/0x84()
[  166.394531] CPU: 0 PID: 0 Comm:  Not tainted 3.13.0-rc4-00291-g002c96b-dirty #2135
[  166.404296] [<0000c4f0>] (unwind_backtrace+0x0/0xe0) from [<0000ae98>] (show_stack+0x10/0x14)
[  166.415039] [<0000ae98>] (show_stack+0x10/0x14) from [<0000f924>] (warn_slowpath_common+0x58/0x78)
[  166.425781] [<0000f924>] (warn_slowpath_common+0x58/0x78) from [<0000f9e8>] (warn_slowpath_null+0x18/0x1c)
[  166.437499] [<0000f9e8>] (warn_slowpath_null+0x18/0x1c) from [<00041004>] (__rcu_read_unlock+0x70/0x84)
[  166.449218] [<00041004>] (__rcu_read_unlock+0x70/0x84) from [<000185a4>] (__sigqueue_alloc+0x98/0x180)
[  166.459960] [<000185a4>] (__sigqueue_alloc+0x98/0x180) from [<00000000>] (  (null))
[  166.467773] ---[ end trace 97ba89e778f73a83 ]---
[  166.475585]
[  166.477539] =====================================
[  166.482421] [ BUG: bad unlock balance detected! ]
[  166.487304] 3.13.0-rc4-00291-g002c96b-dirty #2135 Tainted: G        W
[  166.495117] -------------------------------------
[  166.499999] kworker/0:0/4 is trying to release lock (rcu_read_lock) at:
[  166.507812] [<0001850c>] __sigqueue_alloc+0x0/0x180
[  166.512695] but there are no more locks to release!
[  166.518554]
[  166.518554] other info that might help us debug this:
[  166.525390] 2 locks held by kworker/0:0/4:
[  166.530273]  #0:  (%s%d){.+.+.+}, at: [<00020df4>] process_one_work+0x1f0/0x420
[  166.539062]  #1:  ((&new->work)){+.+.+.}, at: [<00020df4>] process_one_work+0x1f0/0x420
[  166.547851]
[  166.547851] stack backtrace:
[  166.553710] CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G        W    3.13.0-rc4-00291-g002c96b-dirty #2135
[  166.564453] Workqueue: mtdblock1 mtd_blktrans_work
[  166.571289] [<0000c4f0>] (unwind_backtrace+0x0/0xe0) from [<0000ae98>] (show_stack+0x10/0x14)
[  166.582031] [<0000ae98>] (show_stack+0x10/0x14) from [<0003224c>] (print_unlock_imbalance_bug+0xa4/0xd8)
[  166.593749] [<0003224c>] (print_unlock_imbalance_bug+0xa4/0xd8) from [<00036fc4>] (lock_release+0x1ac/0x200)
[  166.605468] [<00036fc4>] (lock_release+0x1ac/0x200) from [<000185a0>] (__sigqueue_alloc+0x94/0x180)
[  166.616210] [<000185a0>] (__sigqueue_alloc+0x94/0x180) from [<01e16940>] (0x1e16940)


