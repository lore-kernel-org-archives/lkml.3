Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118Ab3ICRr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:47:29 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51845 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab3ICRr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:47:27 -0400
Date: Tue, 3 Sep 2013 10:47:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christian Hoffmann <chrmhoffmann@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: omap: panda rcu stall on 3.10.1
Message-ID: <20130903174709.GW3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <521DA180.9010306@gmail.com>
 <52203B54.70902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52203B54.70902@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090317-1542-0000-0000-00000119598E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 08:27:32AM +0200, Christian Hoffmann wrote:
> 
> > This also went to: linaro-kernel@lists.linaro.org
> 
> Hi,
> 
> current linaro kernel on 13.07 (3.10.1.0-1-linaro-omap) shows stack
> below. System is generally quite unstable. Light usage
> (postfix+dovecot...)
> 
> Full dmesg here:
> https://dl.dropboxusercontent.com/u/21820416/rcu.stall.panda

Looks to me like the CPU stall is cascaded problem.  Prior to this in
dmesg, you have several "terminated with status N" messages, where N!=0.

I believe that fixing the problems leading to these messages would be
a good first step.

							Thanx, Paul

> Rgds,
> Chris
> 
> [ 4538.880432] INFO: rcu_sched detected stalls on CPUs/tasks: { 1}
> (detected by 0, t=2103 jiffies, g=1649, c=1648, q=18)
> [ 4538.891723] Backtrace for cpu 0 (current):
> [ 4538.891723] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
> 3.10.1.0-1-linaro-omap #1ubuntu1~ci+130723003933-Ubuntu
> [ 4538.891754] [<c001175d>] (unwind_backtrace+0x1/0x9c) from
> [<c000f625>] (show_stack+0x11/0x14)
> [ 4538.891815] [<c000f625>] (show_stack+0x11/0x14) from [<c00106d5>]
> (smp_send_all_cpu_backtrace+0x49/0x98)
> [ 4538.891815] [<c00106d5>] (smp_send_all_cpu_backtrace+0x49/0x98) from
> [<c007c755>] (rcu_check_callbacks+0x439/0x4ac)
> [ 4538.891815] [<c007c755>] (rcu_check_callbacks+0x439/0x4ac) from
> [<c0036599>] (update_process_times+0x2d/0x4c)
> [ 4538.891876] [<c0036599>] (update_process_times+0x2d/0x4c) from
> [<c005fcfd>] (tick_sched_handle+0x35/0x40)
> [ 4538.891906] [<c005fcfd>] (tick_sched_handle+0x35/0x40) from
> [<c005feed>] (tick_sched_timer+0x31/0x54)
> [ 4538.891937] [<c005feed>] (tick_sched_timer+0x31/0x54) from
> [<c004532b>] (__run_hrtimer+0x5b/0x138)
> [ 4538.891937] [<c004532b>] (__run_hrtimer+0x5b/0x138) from [<c0045bcb>]
> (hrtimer_interrupt+0xdb/0x22c)
> [ 4538.891967] [<c0045bcb>] (hrtimer_interrupt+0xdb/0x22c) from
> [<c0010e13>] (twd_handler+0x1b/0x28)
> [ 4538.891998] [<c0010e13>] (twd_handler+0x1b/0x28) from [<c00783b9>]
> (handle_percpu_devid_irq+0x4d/0xac)
> [ 4538.891998] [<c00783b9>] (handle_percpu_devid_irq+0x4d/0xac) from
> [<c0075ead>] (generic_handle_irq+0x19/0x24)
> [ 4538.892028] [<c0075ead>] (generic_handle_irq+0x19/0x24) from
> [<c000d16d>] (handle_IRQ+0x29/0x68)
> [ 4538.892059] [<c000d16d>] (handle_IRQ+0x29/0x68) from [<c00084db>]
> (gic_handle_irq+0x27/0x50)
> [ 4538.892059] [<c00084db>] (gic_handle_irq+0x27/0x50) from [<c045315b>]
> (__irq_svc+0x3b/0x5c)
> [ 4538.892059] Exception stack(0xc06e3f68 to 0xc06e3fb0)
> [ 4538.892059] 3f60:                   00000000 00000000 00000000
> 00000000 c06e2000 c075f130
> [ 4538.892120] 3f80: c06e2000 c075ea93 c075f130 c06ea594 c045c2e0
> c06e2000 c0fe5908 c06e3fb0
> [ 4538.892120] 3fa0: c007bab1 c0058b48 400f0133 ffffffff
> [ 4538.892120] [<c045315b>] (__irq_svc+0x3b/0x5c) from [<c0058b48>]
> (cpu_startup_entry+0xbc/0x164)
> [ 4538.892120] [<c0058b48>] (cpu_startup_entry+0xbc/0x164) from
> [<c06735f9>] (start_kernel+0x251/0x2ac)
> [ 4538.892120]
> [ 4538.892120] sending IPI to all other CPUs:
> [ 4538.892211] IPI backtrace for cpu 1
> [ 4538.892211]
> [ 4538.892242] CPU: 1 PID: 2064 Comm: clamd Not tainted
> 3.10.1.0-1-linaro-omap #1ubuntu1~ci+130723003933-Ubuntu
> [ 4538.892242] task: edb09500 ti: ec91e000 task.ti: ec91e000
> [ 4538.892272] PC is at 0xb6e2f0d4
> [ 4538.892272] LR is at 0xb6eeec01
> [ 4538.892272] pc : [<b6e2f0d4>]    lr : [<b6eeec01>]    psr: 000f0130
> [ 4538.892272] sp : be8b472c  ip : 62323337  fp : 0000684a
> [ 4538.892303] r10: 0084d750  r9 : 00000200  r8 : e86d6a2f
> [ 4538.892303] r7 : 0a0a0a0a  r6 : 69393e32  r5 : 0080bf24  r4 : 0080bf28
> [ 4538.892333] r3 : 81010100  r2 : 63333438  r1 : 0000000a  r0 : 0080bf24
> [ 4538.892333] Flags: nzcv  IRQs on  FIQs on  Mode USER_32  ISA Thumb
> Segment user
> [ 4538.892333] Control: 50c5387d  Table: acbd404a  DAC: 55555555
> [ 4538.892364]
> [ 4538.892364] R8: 0xe86d69af:
> [ 4538.892364] 69ac  6a6f7254 412e6e61 746e6567 3939332d 00303934
> b1aa3270 25060000 47a83ca7
> [ 4538.892395] 69cc  e4ebc453 91ad979e 23363f8b fd49d9d0 773b48ba
> ad58f7d3 04c351eb 96e4414f
> [ 4538.892395] 69ec  7e1a3ac7 f39072a5 e362cedb b119b3e0 b595375e
> b2137762 b19f99a8 b10dc638
> [ 4538.892395] 6a0c  18060000 2e6e6957 6a6f7254 412e6e61 746e6567
> 3939332d 00303534 b23ade28
> [ 4538.892395] 6a2c  18060000 2e6e6957 6a6f7254 462e6e61 61656b61
> 37342d76 00373131 ac58376e
> [ 4538.892395] 6a4c  72542e6e 6e616a6f 3434382e 35313336 3e55c600
> 412e6eb2 72617764 61472e65
> [ 4538.892517] 6a6c  6176656d 2d65636e 34393132 55b20037 1604b173
> 2e6e6957 6a6f7254 462e6e61
> [ 4538.892547] 6a8c  61656b61 37342d76 00343131 b652e2c0 72542e6e
> 6e616a6f 7075532e 756a7265
> [ 4538.892547] 6aac  322d6e61 fb003731 15b23a2b 2e6e6957 6a6f7254
> 412e6e61 746e6567 3939332d
> [ 4538.892547] CPU: 1 PID: 2064 Comm: clamd Not tainted
> 3.10.1.0-1-linaro-omap #1ubuntu1~ci+130723003933-Ubuntu
> [ 4538.892547] [<c001175d>] (unwind_backtrace+0x1/0x9c) from
> [<c000f625>] (show_stack+0x11/0x14)
> [ 4538.892639] [<c000f625>] (show_stack+0x11/0x14) from [<c0010819>]
> (handle_IPI+0xd5/0x158)
> [ 4538.892669] [<c0010819>] (handle_IPI+0xd5/0x158) from [<c00084ff>]
> (gic_handle_irq+0x4b/0x50)
> [ 4538.892669] [<c00084ff>] (gic_handle_irq+0x4b/0x50) from [<c0453369>]
> (__irq_usr+0x49/0x60)
> [ 4538.892700] Exception stack(0xec91ffb0 to 0xec91fff8)
> [ 4538.892700] ffa0:                                     0080bf24
> 0000000a 63333438 81010100
> [ 4538.892730] ffc0: 0080bf28 0080bf24 69393e32 0a0a0a0a e86d6a2f
> 00000200 0084d750 0000684a
> [ 4538.892730] ffe0: 62323337 be8b472c b6eeec01 b6e2f0d4 000f0130 ffffffff
> 
> 

