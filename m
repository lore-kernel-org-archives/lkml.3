Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaCEIRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 03:17:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43187 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbaCEIRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 03:17:01 -0500
Date: Wed, 5 Mar 2014 09:16:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: tglx@linutronix.de, mingo@kernel.org, dvhart@linux.intel.com,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: futex funkiness -- massive lockups
Message-ID: <20140305081644.GR9987@twins.programming.kicks-ass.net>
References: <1393983784.2512.40.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393983784.2512.40.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 05:43:04PM -0800, Davidlohr Bueso wrote:
> Hi,
> 
> A large amount of lockups are seen on a 480 core system doing some sort
> of database-like workload. All except one are soft lockups. This is a
> SLES11 system with most of the recent futex changes backported,
> including commits 63b1a816, b0c29f79, 99b60ce6, a52b89eb, 0d00c7b2,
> 5cdec2d8 and f12d5bfc.
> 
> [212071.494920]  [<ffffffff810589e5>] load_balance+0xa5/0x470
> [212071.494920]  [<ffffffff81058f13>] rebalance_domains+0x163/0x220
> [212071.494920]  [<ffffffff81059144>] run_rebalance_domains+0x44/0x60
> [212071.494920]  [<ffffffff810677df>] __do_softirq+0x11f/0x260
> [212071.494920]  [<ffffffff81469fdc>] call_softirq+0x1c/0x30
> [212071.494920]  [<ffffffff81004435>] do_softirq+0x65/0xa0
> [212071.494920]  [<ffffffff810675a5>] irq_exit+0xc5/0xe0
> [212071.494920]  [<ffffffff81026588>] smp_apic_timer_interrupt+0x68/0xa0
> [212071.494920]  [<ffffffff81469773>] apic_timer_interrupt+0x13/0x20
> [212071.494920]  [<ffffffff81460ec5>] _raw_spin_lock+0x15/0x20
> [212071.494920]  [<ffffffff8109626a>] futex_wake+0xba/0x180
> [212071.494920]  [<ffffffff810987c4>] do_futex+0x94/0x1c0
> [212071.494920]  [<ffffffff81098972>] sys_futex+0x82/0x170
> [212071.494920]  [<ffffffff81468d92>] system_call_fastpath+0x16/0x1b
> 

Like Linus said; that looks like its stuck in the load balancer. Now 480
is certainly more CPUs that usual. However, SGI ran with lots more and I
don't recall them seeing soft lockups from this.

OTOH I do know the softirq runs for more than a softirq should; even on
moderate systems.
