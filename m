Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaGaC6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 22:58:47 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60454 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbaGaC6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 22:58:46 -0400
Date: Wed, 30 Jul 2014 19:58:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [x86,kaslr] [    0.000000] WARNING: CPU: 0 PID: 0 at
 arch/x86/kernel/cpu/common.c:1422 warn_pre_alternatives()
Message-ID: <20140731025837.GC11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140730140756.GN16537@localhost>
 <20140730141732.GP16537@localhost>
 <20140730155207.GM11241@linux.vnet.ibm.com>
 <20140731024212.GB10184@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731024212.GB10184@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073102-1542-0000-0000-000003A8A6AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 10:42:12AM +0800, Fengguang Wu wrote:
> On Wed, Jul 30, 2014 at 08:52:07AM -0700, Paul E. McKenney wrote:
> > On Wed, Jul 30, 2014 at 10:17:32PM +0800, Fengguang Wu wrote:
> > > On Wed, Jul 30, 2014 at 10:07:56PM +0800, Fengguang Wu wrote:
> > > > Hi Andy,
> > > > 
> > > > Here is another WARNING message for the same commit.
> > > > 
> > > > commit d07c7f1ed61789e175fa975134855be32263be2c
> > > > Author:     Andy Lutomirski <luto@amacapital.net>
> > > > AuthorDate: Tue Jul 15 18:34:20 2014 -0700
> > > > Commit:     Andy Lutomirski <luto@amacapital.net>
> > > > CommitDate: Wed Jul 16 10:01:27 2014 -0700
> > > > 
> > > >     x86,kaslr: Use MSR_KVM_GET_RNG_SEED for KASLR if available
> > > >     
> > > >     It's considerably better than any of the alternatives on KVM.
> > > >     
> > > >     Rather than reinventing all of the cpu feature query code, this fixes
> > > >     native_cpuid to work in PIC objects.
> > > >     
> > > >     I haven't combined it with boot/cpuflags.c's cpuid implementation:
> > > >     including asm/processor.h from boot/cpuflags.c results in a flood of
> > > >     unrelated errors, and fixing it might be messy.
> > > >     
> > > >     Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> > > > 
> > > > +-------------------------------------------------------------------------+------------+------------+
> > > > |                                                                         | c6f07a6360 | d07c7f1ed6 |
> > > > +-------------------------------------------------------------------------+------------+------------+
> > > > | boot_successes                                                          | 1000       | 636        |
> > > > | boot_failures                                                           | 0          | 84         |
> > > > | WARNING:CPU:PID:at_arch/x86/kernel/cpu/common.c:warn_pre_alternatives() | 0          | 84         |
> > > > | BUG:unable_to_handle_kernel_NULL_pointer_dereference                    | 0          | 84         |
> > > > | Oops                                                                    | 0          | 84         |
> > > > | RIP:__free_pages_bootmem                                                | 0          | 84         |
> > > > | Kernel_panic-not_syncing:Fatal_exception                                | 0          | 84         |
> > > > | backtrace:free_all_bootmem                                              | 0          | 84         |
> > > > | backtrace:mem_init                                                      | 0          | 84         |
> > > > +-------------------------------------------------------------------------+------------+------------+
> > > > 
> > > > [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> > > > [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x0
> > > > [    0.000000] ------------[ cut here ]------------
> > > > [    0.000000] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:1422 warn_pre_alternatives+0x1e/0x20()
> > > > [    0.000000] You're using static_cpu_has before alternatives have run!
> > > > [    0.000000] Modules linked in:
> > > > [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.16.0-rc5-00004-gd07c7f1 #4
> > > > [    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> > > > [    0.000000]  0000000000000000 ffffffff81803c18 ffffffff813a7bd2 ffffffff81803c60
> > > > [    0.000000]  ffffffff81803c50 ffffffff810a5485 ffffffff810102f9 ffffffff81803e08
> > > > [    0.000000]  0000000000000002 000000000000077c 0000000000000000 ffffffff81803cb0
> > > > [    0.000000] Call Trace:
> > > > [    0.000000]  [<ffffffff813a7bd2>] dump_stack+0x4d/0x66
> > > > [    0.000000]  [<ffffffff810a5485>] warn_slowpath_common+0x7f/0x98
> > > > [    0.000000]  [<ffffffff810102f9>] ? warn_pre_alternatives+0x1e/0x20
> > > > [    0.000000]  [<ffffffff810a54ea>] warn_slowpath_fmt+0x4c/0x4e
> > > > [    0.000000]  [<ffffffff813b14e3>] ? restore_args+0x30/0x30
> > > > [    0.000000]  [<ffffffff810102f9>] warn_pre_alternatives+0x1e/0x20
> > > > [    0.000000]  [<ffffffff810378b5>] __do_page_fault+0x1bd/0x7ca
> > > > [    0.000000]  [<ffffffff810f5782>] ? console_unlock+0x377/0x3c1
> > > > [    0.000000]  [<ffffffff810e912e>] ? trace_hardirqs_off+0xd/0xf
> > > > [    0.000000]  [<ffffffff813afcc5>] ? _raw_spin_unlock_irqrestore+0x40/0x5e
> > > > [    0.000000]  [<ffffffff81b93d22>] ? __next_mem_range_rev+0x205/0x232
> > > > [    0.000000]  [<ffffffff810e90e0>] ? trace_hardirqs_off_caller+0xe7/0x128
> > > > [    0.000000]  [<ffffffff81226d8a>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> > > > [    0.000000]  [<ffffffff81037ee4>] do_page_fault+0x22/0x27
> > > > [    0.000000]  [<ffffffff813b2378>] page_fault+0x28/0x30
> > > > [    0.000000]  [<ffffffff81b74f76>] ? __free_pages_bootmem+0x2d/0xf9
> > > > [    0.000000]  [<ffffffff81b78d61>] __free_memory_core+0xa7/0xbe
> > > > [    0.000000]  [<ffffffff81b78fe9>] free_all_bootmem+0x51/0xd2
> > > > [    0.000000]  [<ffffffff81b67188>] mem_init+0x5c/0x8d
> > > > [    0.000000]  [<ffffffff81b53cca>] start_kernel+0x1f7/0x53d
> > > > [    0.000000]  [<ffffffff81b53814>] ? set_init_arg+0x55/0x55
> > > > [    0.000000]  [<ffffffff81b53120>] ? early_idt_handlers+0x120/0x120
> > > > [    0.000000]  [<ffffffff81b53471>] x86_64_start_reservations+0x2a/0x2c
> > > > [    0.000000]  [<ffffffff81b535b3>] x86_64_start_kernel+0x140/0x14d
> > > > [    0.000000] ---[ end trace e4962b91bd705c64 ]---
> > > > [    0.000000] BUG: unable to handle kernel NULL pointer dereference at 000000000000077c
> > > 
> > > 
> > > Interestingly, the other bisect result for the above WARNING message
> > > is
> > > 
> > > commit ddfb3b363440172d62ce62fbffdf046670d3ce2b
> > 
> > This is an obsolete commit, but...
> 
> Paul, would you suggest me to test any new commit or branch HEAD?

The latest branch containing this commit is rcu/dev.2014.07.28e,
might be worth a shot.

							Thanx, Paul

