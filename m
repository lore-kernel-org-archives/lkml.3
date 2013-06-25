Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3FYHo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:44:28 -0400
Received: from ozlabs.org ([203.10.76.45]:52693 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab3FYHoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:44:25 -0400
Date: Tue, 25 Jun 2013 17:44:23 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Rojhalat Ibrahim <imr@rtschenk.de>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: Regression in RCU subsystem in latest mainline kernel
Message-ID: <20130625074422.GB29957@concordia>
References: <1626500.7WAVXjfS9F@pcimr>
 <20130614122800.GL5146@linux.vnet.ibm.com>
 <1645938.As0LR1yeVd@pcimr>
 <1371243967.9844.338.camel@gandalf.local.home>
 <1371261741.21896.20.camel@pasglop>
 <20130617074213.GA3589@concordia>
 <20130619040906.GA5146@linux.vnet.ibm.com>
 <20130625071914.GA29957@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625071914.GA29957@concordia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 05:19:14PM +1000, Michael Ellerman wrote:
> 
> Here's another trace from 3.10-rc7 plus a few local patches.

And here's another with CONFIG_RCU_CPU_STALL_INFO=y in case that's useful:

PASS running test_pmc5_6_overuse()
INFO: rcu_sched self-detected stall on CPU
	8: (1 GPs behind) idle=8eb/140000000000002/0 softirq=215/220 
	 (t=2100 jiffies g=18446744073709551583 c=18446744073709551582 q=13)
cpu 0x8: Vector: 0  at [c0000003ea03eae0]
    pc: c00000000011d9b0: .rcu_check_callbacks+0x450/0x910
    lr: c00000000011d9b0: .rcu_check_callbacks+0x450/0x910
    sp: c0000003ea03ec40
   msr: 9000000000009032
  current = 0xc0000003ebf9f4a0
  paca    = 0xc00000000fdc2400	 softe: 0	 irq_happened: 0x00
    pid   = 2444, comm = power8-events
enter ? for help
[c0000003ea03ed70] c000000000094cd0 .update_process_times+0x40/0x90
[c0000003ea03ee00] c0000000000df050 .tick_sched_handle.isra.13+0x20/0xa0
[c0000003ea03ee80] c0000000000df2bc .tick_sched_timer+0x5c/0xa0
[c0000003ea03ef20] c0000000000b3728 .__run_hrtimer+0x98/0x260
[c0000003ea03efc0] c0000000000b4738 .hrtimer_interrupt+0x138/0x3c0
[c0000003ea03f0d0] c00000000001cd34 .timer_interrupt+0x124/0x2f0
[c0000003ea03f180] c00000000000a4f4 restore_check_irq_replay+0x68/0xa8
--- Exception: 901 (Decrementer) at c000000000093ad4 .run_timer_softirq+0x74/0x360
[c0000003ea03f580] c000000000089ac4 .__do_softirq+0x174/0x350
[c0000003ea03f6a0] c000000000089ea8 .irq_exit+0xb8/0x100
[c0000003ea03f720] c00000000001cd68 .timer_interrupt+0x158/0x2f0
[c0000003ea03f7d0] c00000000000a4f4 restore_check_irq_replay+0x68/0xa8
--- Exception: 901 (Decrementer) at c00000000014a520 .task_function_call+0x60/0x70
[c0000003ea03fac0] c00000000014a634 .perf_event_enable+0x104/0x1c0 (unreliable)
[c0000003ea03fb70] c0000000001495ec .perf_event_for_each_child+0x5c/0xf0
[c0000003ea03fc00] c00000000014cd78 .perf_ioctl+0x108/0x400
[c0000003ea03fca0] c0000000001d9aa0 .do_vfs_ioctl+0xb0/0x740
[c0000003ea03fd80] c0000000001da188 .SyS_ioctl+0x58/0xb0
[c0000003ea03fe30] c000000000009d54 syscall_exit+0x0/0x98
--- Exception: c01 (System Call) at 00001fffffee03d0
SP (3ffff5e7cc90) is in userspace


cheers
