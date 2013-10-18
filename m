Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab3JRNsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:48:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab3JRNsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:48:04 -0400
Date: Fri, 18 Oct 2013 09:47:52 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: MAX_LOCKDEP_CHAINS too low! (sysfs?)
Message-ID: <20131018134752.GA31269@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG: MAX_LOCKDEP_CHAINS too low!
turning off the locking correctness validator.
Please attach the output of /proc/lock_stat to the bug report
CPU: 1 PID: 2102862 Comm: trinity-main Not tainted 3.12.0-rc5+ #27
Hardware name: Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H, BIOS F12a 04/23/2010
 ffffffff82427e90 ffff88006f9cd938 ffffffff816db90c 000000000104c014
 ffff88006f9cda00 ffffffff810c40cd ffffffff810bf11e ffff88006f9cd970
 ffffffff810bf645 ffff8800c9ee1550 ffff88012a000a18 00007fffce3189e8
Call Trace:
 [<ffffffff816db90c>] dump_stack+0x4e/0x82
 [<ffffffff810c40cd>] __lock_acquire+0x1b6d/0x1bd0
 [<ffffffff810bf11e>] ? put_lock_stats.isra.28+0xe/0x40
 [<ffffffff810bf645>] ? lock_release_holdtime.part.29+0xe5/0x160
 [<ffffffff810d04f2>] ? __module_text_address+0x12/0x60
 [<ffffffff810d4b1f>] ? is_module_text_address+0x2f/0x60
 [<ffffffff8106e580>] ? __kernel_text_address+0x50/0x70
 [<ffffffff81006507>] ? print_context_stack+0x87/0xf0
 [<ffffffff810c48d3>] lock_acquire+0x93/0x1e0
 [<ffffffff816d95d7>] ? get_partial_node.isra.41+0x49/0x20a
 [<ffffffff816e4441>] _raw_spin_lock+0x41/0x80
 [<ffffffff816d95d7>] ? get_partial_node.isra.41+0x49/0x20a
 [<ffffffff816d95d7>] get_partial_node.isra.41+0x49/0x20a
 [<ffffffff810c13b7>] ? check_usage_backwards+0x87/0x150
 [<ffffffff816d9918>] __slab_alloc+0x180/0x4dd
 [<ffffffff810c1330>] ? print_shortest_lock_dependencies+0x1d0/0x1d0
 [<ffffffff81249ea8>] ? sysfs_open_file+0xb8/0x230
 [<ffffffff810bf086>] ? __lock_is_held+0x56/0x80
 [<ffffffff811a304c>] kmem_cache_alloc_trace+0x2dc/0x3a0
 [<ffffffff81249ea8>] ? sysfs_open_file+0xb8/0x230
 [<ffffffff81249ea8>] sysfs_open_file+0xb8/0x230
 [<ffffffff811c129b>] do_dentry_open+0x25b/0x310
 [<ffffffff812dfcbc>] ? security_inode_permission+0x1c/0x30
 [<ffffffff81249df0>] ? sysfs_schedule_callback+0x1e0/0x1e0
 [<ffffffff811c1399>] finish_open+0x49/0x60
 [<ffffffff811d3af4>] do_last+0x5b4/0x1200
 [<ffffffff811d480e>] path_openat+0xce/0x6b0
 [<ffffffff8100b324>] ? native_sched_clock+0x24/0x80
 [<ffffffff811d5577>] do_filp_open+0x47/0xa0
 [<ffffffff811e4daf>] ? __alloc_fd+0xaf/0x200
 [<ffffffff811c2829>] do_sys_open+0x139/0x220
 [<ffffffff81010b95>] ? syscall_trace_enter+0x155/0x2a0
 [<ffffffff811c292e>] SyS_open+0x1e/0x20
 [<ffffffff816ed9e4>] tracesys+0xdd/0xe2


/proc/lock_stat is at http://www.codemonkey.org.uk/junk/locks-2013-10-18.txt

Probably not going to get time to dig into this before kernel summit,
but posting in case it's something obvious..

	Dave

