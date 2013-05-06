Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3EFT1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 15:27:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab3EFT1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 15:27:00 -0400
Date: Mon, 6 May 2013 15:26:53 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_init allocation failure trace on bootup
Message-ID: <20130506192653.GA16819@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130506175647.GA1309@redhat.com>
 <20130506190522.GD3501@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130506190522.GD3501@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 12:05:22PM -0700, Paul E. McKenney wrote:
 > On Mon, May 06, 2013 at 01:56:47PM -0400, Dave Jones wrote:
 > > [    0.000000]  RCU debugfs-based tracing is enabled.
 > > [    0.000000]  RCU lockdep checking is enabled.
 > > [    0.000000] ------------[ cut here ]------------
 > > [    0.000000] WARNING: at mm/nobootmem.c:215 ___alloc_bootmem_nopanic+0x3a/0x7d()
 > > [    0.000000] Modules linked in:
 > > [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.9.0+ #128
 > > [    0.000000] Hardware name:                  /D975XBX, BIOS BX97510J.86A.1209.2006.0601.1340 06/01/2006
 > > [    0.000000]  ffffffff819f4246 ffffffff81c01e68 ffffffff816a0db2 ffffffff81c01ea8
 > > [    0.000000]  ffffffff8104b1a0 ffffffff819e1078 0000000000000000 0000000000000008
 > > [    0.000000]  ffffffffffffffff 0000000000000040 0000000000000000 ffffffff81c01eb8
 > > [    0.000000] Call Trace:
 > > [    0.000000]  [<ffffffff816a0db2>] dump_stack+0x19/0x1b
 > > [    0.000000]  [<ffffffff8104b1a0>] warn_slowpath_common+0x70/0xa0
 > > [    0.000000]  [<ffffffff8104b1ea>] warn_slowpath_null+0x1a/0x20
 > > [    0.000000]  [<ffffffff81ef8914>] ___alloc_bootmem_nopanic+0x3a/0x7d
 > > [    0.000000]  [<ffffffff81ef8b87>] __alloc_bootmem+0x13/0x39
 > > [    0.000000]  [<ffffffff81f090ad>] alloc_bootmem_cpumask_var+0x1a/0x21
 > > [    0.000000]  [<ffffffff81ef1f5a>] rcu_init+0x7f/0x261
 > > [    0.000000]  [<ffffffff81ef4acb>] ? perf_event_init+0x178/0x181
 > > [    0.000000]  [<ffffffff81ed6c79>] start_kernel+0x232/0x3d3
 > > [    0.000000]  [<ffffffff81ed6846>] ? repair_env_string+0x5e/0x5e
 > > [    0.000000]  [<ffffffff81ed6577>] x86_64_start_reservations+0x2a/0x2c
 > > [    0.000000]  [<ffffffff81ed6646>] x86_64_start_kernel+0xcd/0xd1
 > > [    0.000000] ---[ end trace 0acfc82c197165dd ]---
 > > [    0.000000]  Experimental no-CBs for all CPUs
 > > [    0.000000]  Experimental no-CBs CPUs: 0-1.
 > > [    0.000000] NO_HZ: Full dynticks CPUs: 1.
 > 
 > Do you have commit fa0f93cd6a (rcu: Don't allocate bootmem from rcu_init())?
 > If not, could you please try applying it?

That commit isn't in Linus tree.

	Dave
