Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934426AbaGPORR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:17:17 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38822 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934359AbaGPORO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:17:14 -0400
Date: Wed, 16 Jul 2014 07:17:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, fabf@skynet.be, bobby.prani@gmail.com,
        davidshan@tencent.com, joe@perches.com, keescook@chromium.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.17
Message-ID: <20140716141707.GU8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140713184237.GA30855@linux.vnet.ibm.com>
 <20140716115046.GC28434@gmail.com>
 <20140716131322.GA16396@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716131322.GA16396@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071614-8236-0000-0000-000003E15E7D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 03:13:22PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > Hello, Ingo,
> > > 
> > > The changes in this series include:
> > > 
> > > 1.	Update RCU documentation.  These were posted to LKML at
> > > 	https://lkml.org/lkml/2014/7/7/650.
> > > 
> > > 2.	Miscellaneous fixes.  These were posted to LKML at
> > > 	https://lkml.org/lkml/2014/7/7/678.
> > > 
> > > 3.	Maintainership changes.  These were posted to LKML at
> > > 	https://lkml.org/lkml/2014/7/7/713, with a couple of
> > > 	additional at https://lkml.org/lkml/2014/7/3/812 and
> > > 	https://lkml.org/lkml/2014/6/2/585.
> > > 
> > > 4.	Torture-test updates.  These were posted to LKML at
> > > 	https://lkml.org/lkml/2014/7/7/816.
> > > 
> > > 5.	Callback-offloading changes.  These were posted to LKML at
> > > 	https://lkml.org/lkml/2014/7/7/1007.
> > > 
> > > All of these have been exposed to -next testing.
> 
> JFYI, the attached x86 (rand!-) config crashes on early bootup:
> 
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:1439 warn_pre_alternatives+0x1e/0x20()
> [    0.000000] You're using static_cpu_has before alternatives have run!
> [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc5+ #236363
> [    0.000000] Hardware name: System manufacturer System Product Name/A8N-E, BIOS ASUS A8N-E ACPI BIOS Revision 1008 08/22/2005
> [    0.000000]  0000000000000000 ffffffff82787c60 ffffffff81ff4ec0 ffffffff82787ca8
> [    0.000000]  ffffffff82787c98 ffffffff810651ac ffffffff81011531 ffffffff82787e48
> [    0.000000]  0000000000000000 0000000000000000 ffffffff827cf880 ffffffff82787cf8
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff81ff4ec0>] dump_stack+0x4d/0x66
> [    0.000000]  [<ffffffff810651ac>] warn_slowpath_common+0x7a/0x93
> [    0.000000]  [<ffffffff81011531>] ? warn_pre_alternatives+0x1e/0x20
> [    0.000000]  [<ffffffff81065239>] warn_slowpath_fmt+0x4c/0x4e
> [    0.000000]  [<ffffffff82005817>] ? irq_return+0x7/0x7
> [    0.000000]  [<ffffffff81011531>] warn_pre_alternatives+0x1e/0x20
> [    0.000000]  [<ffffffff81033d31>] __do_page_fault+0xc3/0x43f
> [    0.000000]  [<ffffffff81005347>] ? print_context_stack+0x6a/0xb6
> [    0.000000]  [<ffffffff810045f1>] ? dump_trace+0x27d/0x294
> [    0.000000]  [<ffffffff815b185b>] ? number.isra.1+0x127/0x22c
> [    0.000000]  [<ffffffff8109abe2>] ? print_time.part.5+0x58/0x5c
> [    0.000000]  [<ffffffff81086a9a>] ? sched_clock_cpu+0x11/0xb9
> [    0.000000]  [<ffffffff810340ef>] do_page_fault+0x1e/0x54
> [    0.000000]  [<ffffffff82005817>] ? irq_return+0x7/0x7
> [    0.000000]  [<ffffffff82006872>] page_fault+0x22/0x30
> [    0.000000]  [<ffffffff815b65fa>] ? __bitmap_or+0x15/0x28
> [    0.000000]  [<ffffffff82c876f0>] rcu_init_one+0x4c0/0x55d
> [    0.000000]  [<ffffffff82c87b00>] rcu_init+0x270/0x2da
> [    0.000000]  [<ffffffff82c6ec82>] start_kernel+0x24f/0x4d2
> [    0.000000]  [<ffffffff82c6e841>] ? set_init_arg+0x53/0x53
> [    0.000000]  [<ffffffff82c6e453>] x86_64_start_reservations+0x2a/0x2c
> [    0.000000]  [<ffffffff82c6e546>] x86_64_start_kernel+0xf1/0xf4
> [    0.000000] ---[ end trace 4650963e41188009 ]---
> [    0.000000] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    0.000000] IP: [<ffffffff815b65fa>] __bitmap_or+0x15/0x28
> [    0.000000] PGD 0 
> [    0.000000] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W     3.16.0-rc5+ #236363
> [    0.000000] Hardware name: System manufacturer System Product Name/A8N-E, BIOS ASUS A8N-E ACPI BIOS Revision 1008 08/22/2005
> [    0.000000] task: ffffffff827a3480 ti: ffffffff82784000 task.ti: ffffffff82784000
> [    0.000000] RIP: 0010:[<ffffffff815b65fa>]  [<ffffffff815b65fa>] __bitmap_or+0x15/0x28
> [    0.000000] RSP: 0000:ffffffff82787ef8  EFLAGS: 00010002
> [    0.000000] RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 0000000000000001
> [    0.000000] RDX: 0000000000000000 RSI: ffff880000019800 RDI: ffff880000019800
> [    0.000000] RBP: ffffffff82787ef8 R08: 0000000000000000 R09: 0000000000000000
> [    0.000000] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff827cf880
> [    0.000000] R13: 0000000000000002 R14: ffffffff827cf880 R15: 00000000001cd000
> [    0.000000] FS:  0000000000000000(0000) GS:ffff88003f800000(0000) knlGS:0000000000000000
> [    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    0.000000] CR2: 0000000000000000 CR3: 000000000279e000 CR4: 00000000000006b0
> [    0.000000] Stack:
> [    0.000000]  ffffffff82787f50 ffffffff82c876f0 ffffffff83b7e7a0 0000000000000001
> [    0.000000]  0000000000000082 0000000200000000 00000000ffffffff ffffffff82d37920
> [    0.000000]  ffff88003ffbba40 ffffffff82d3e890 0000000000000000 ffffffff82787f80
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff82c876f0>] rcu_init_one+0x4c0/0x55d
> [    0.000000]  [<ffffffff82c87b00>] rcu_init+0x270/0x2da
> [    0.000000]  [<ffffffff82c6ec82>] start_kernel+0x24f/0x4d2
> [    0.000000]  [<ffffffff82c6e841>] ? set_init_arg+0x53/0x53
> [    0.000000]  [<ffffffff82c6e453>] x86_64_start_reservations+0x2a/0x2c
> [    0.000000]  [<ffffffff82c6e546>] x86_64_start_kernel+0xf1/0xf4
> [    0.000000] Code: 4c 89 04 c7 4d 09 c1 48 ff c0 eb e8 31 c0 4d 85 c9 0f 95 c0 5d c3 55 48 63 c9 31 c0 48 83 c1 3f 48 89 e5 48 c1 e9 06 39 c1 7e 11 <4c> 8b 04 c2 4c 0b 04 c6 4c 89 04 c7 48 ff c0 eb eb 5d c3 55 48 
> [    0.000000] RIP  [<ffffffff815b65fa>] __bitmap_or+0x15/0x28
> [    0.000000]  RSP <ffffffff82787ef8>
> [    0.000000] CR2: 0000000000000000
> [    0.000000] ---[ end trace 4650963e4118800a ]---
> [    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
> [    0.000000] Rebooting in 1 seconds..Press any key to enter the menu
> 
> Excluding the new RCU bits from tip:master makes it boot.
> 
> Any idea what's wrong?

Looks like you have a setup that has NO_HZ_FULL=y, but that somehow
avoids having a non-NULL tick_nohz_full_mask at rcu_init() time.  But you
probably knew that already.  And of course when I test locally with the
same RCU-related and NO_HZ_FULL-related configs, it all works just fine.
Perhaps there is some interaction with some other code in -tip.

So let's see...

Now your .config has CONFIG_NO_HZ_FULL_ALL=y and therefore also has
CONFIG_RCU_NOCB_CPU_ALL=y.  In that case, there is no point in doing the
cpumask_or() because all the bits are already set.  So the only time
that this cpumask_or() matters is when CONFIG_RCU_NOCB_CPU_ALL==n and
an explicit nohz_full= mask was specified at boot time.  So one reasonable
change is to replace the #ifndef guarding the cpumask_or() with:

	#if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_RCU_NOCB_CPU_ALL)

I am now looking to see how tick_nohz_full_mask might be NULL in this
situation.  Depending on what I find, I might insert a check for that.

							Thanx, Paul

