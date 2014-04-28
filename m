Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbaD1N0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:26:21 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:51901 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041AbaD1N0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:26:15 -0400
X-Greylist: delayed 1313 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Apr 2014 09:26:14 EDT
Date: Mon, 28 Apr 2014 16:04:18 +0300 (EEST)
From: Meelis Roos <mroos@ut.ee>
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, aaro.koskinen@iki.fi, hughd@google.com,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Fix several sparc64 THP bugs.
In-Reply-To: <alpine.SOC.1.00.1404262308350.3958@math.ut.ee>
Message-ID: <alpine.SOC.1.00.1404281602520.1407@math.ut.ee>
References: <20140425.154337.1159533755150765063.davem@davemloft.net> <alpine.SOC.1.00.1404262308350.3958@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> V100 boots up fine but as soon as I start aptitude, it just hangs with 
> nothing on console (tried it twice).

Got this on V100 after retries (truncated to width by minicom):

[ 1286.980912] BUG: soft lockup - CPU#0 stuck for 22s! [aptitude:2520]
[ 1287.063316] Modules linked in: ipv6 loop fuse ohci_pci ohci_hcd usbcore sg sr_mod cdrom usb_commn
[ 1287.181103] irq event stamp: 23310
[ 1287.225692] hardirqs last  enabled at (23309): [<0000000000404b1c>] rtrap_xcall+0x18/0x20
[ 1287.333358] hardirqs last disabled at (23310): [<0000000000426b00>] valid_addr_bitmap_patch+0x388
[ 1287.455764] softirqs last  enabled at (23308): [<000000000045916c>] __do_softirq+0x18c/0x240
[ 1287.566730] softirqs last disabled at (23301): [<000000000042b9e0>] do_softirq_own_stack+0x20/0x0
[ 1287.684574] CPU: 0 PID: 2520 Comm: aptitude Not tainted 3.15.0-rc2-dirty #115
[ 1287.778385] task: ffffff006e230fc0 ti: ffffff006c428000 task.ti: ffffff006c428000
[ 1287.876805] TSTATE: 0000000080001604 TPC: 000000000040796c TNPC: 0000000000407970 Y: 00000ef4   d
[ 1288.006079] TPC: <sparc64_realfault_common+0x8/0x20>
[ 1288.071290] g0: ffffff006e0a72f0 g1: 0000000000000000 g2: 0000000000000000 g3: 0000000000000598
[ 1288.185720] g4: ffffff006e230fc0 g5: 000000000000ff00 g6: ffffff006c428000 g7: 0000000000000030
[ 1288.300122] o0: 0000000000000001 o1: ffffff006c428400 o2: 0000000000637c20 o3: 0000000000000ef4
[ 1288.414524] o4: ffffff006e559240 o5: 0000000000000003 sp: ffffff006c42b491 ret_pc: 0000000000404c
[ 1288.533500] RPC: <rtrap_xcall+0x18/0x20>
[ 1288.585002] l0: 0000000000001000 l1: 0000000011001603 l2: 000000000040796c l3: 0000000000000000
[ 1288.699432] l4: 0000000000000003 l5: 00000000ffa2ce8b l6: ffffff006c428000 l7: 0000000080001004
[ 1288.813834] i0: 00000000ffa2cf28 i1: ffffff006c428048 i2: 0000000000000000 i3: 0000010093604ee0
[ 1288.928236] i4: 00000000ffa2cf28 i5: 0000000000000000 i6: ffffff006c42b5f1 i7: 000000000042c728
[ 1289.042645] I7: <fault_in_user_windows+0x68/0x100>
[ 1289.105570] Call Trace:
[ 1289.137685]  [0000000000637c1c] ___copy_to_user+0x121c/0x13c0
[ 1289.213230]  [0000000000404a90] __handle_user_windows+0x0/0x10
[ 1289.290271] Kernel panic - not syncing: softlockup: hung tasks
[ 1289.366915] CPU: 0 PID: 2520 Comm: aptitude Not tainted 3.15.0-rc2-dirty #115
[ 1289.460732] Call Trace:
[ 1289.492836]  [00000000007e1290] panic+0xb8/0x244
[ 1289.553522]  [00000000004bcd7c] watchdog_timer_fn+0x13c/0x160
[ 1289.629074]  [000000000047930c] __run_hrtimer.isra.20+0x4c/0x140
[ 1289.708035]  [0000000000479928] hrtimer_interrupt+0xc8/0x240
[ 1289.782434]  [000000000042f730] timer_interrupt+0x50/0xa0
[ 1289.853398]  [0000000000426b0c] valid_addr_bitmap_patch+0x44/0x1b8
[ 1289.934653]  [000000000040796c] sparc64_realfault_common+0x8/0x20
[ 1290.014770]  [0000000000637c1c] ___copy_to_user+0x121c/0x13c0
[ 1290.090304]  [0000000000404a90] __handle_user_windows+0x0/0x10

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
