Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab3IKR0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:26:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21270 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680Ab3IKR0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:26:21 -0400
Date: Wed, 11 Sep 2013 13:25:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@akamai.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Subject: Re: Regression :-) Re: [GIT PULL RESEND] x86/jumpmplabel changes for
 v3.12-rc1
Message-ID: <20130911172552.GB6870@phenom.dumpdata.com>
References: <201309110248.r8B2miI2032449@terminus.zytor.com>
 <20130911134717.GA10925@phenom.dumpdata.com>
 <20130911135745.GB11043@phenom.dumpdata.com>
 <20130911142545.GA11364@phenom.dumpdata.com>
 <20130911105633.1c029147@gandalf.local.home>
 <20130911152149.GA22076@phenom.dumpdata.com>
 <20130911114708.1b42aec0@gandalf.local.home>
 <20130911161745.GA5884@phenom.dumpdata.com>
 <20130911130507.44a2b115@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911130507.44a2b115@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 01:05:07PM -0400, Steven Rostedt wrote:
> 
> [ Fixed Jason Baron's email so that he can join the conversation ]
> 
> On Wed, 11 Sep 2013 12:17:45 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > On Wed, Sep 11, 2013 at 11:47:08AM -0400, Steven Rostedt wrote:
> 
> > [    4.966101] Kernel command line: debug selinux=0 earlyprintk=xen console=hvc0 xencons=hvc0 loglevel=10 pci=resource_alignment=00:13.2 xen-pciback.hide=(08:07.0)(08:06.0)(00:12.0)(00:12.1)(00:12.2)(00:13.0)(00:13.1)(00:13.2)(00:14.5) xen-pciback.passthrough=0
> > [    4.966892] op trace_clock_global+0x6b/0x120
> > [    4.966895] CPU: 0 PID: 0 Comm: swapper Not tainted 3.11.0upstream-09031-ga22a0fd-dirty #1
> > [    4.966897] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080014  07/18/2008
> > [    4.966899]  ffffffff810542e0 ffffffff81c01e28 ffffffff816a0cf3 0000000000000001
> > [    4.966903]  ffffffff81ca8598 ffffffff81c01e88 ffffffff81051e0a ffffffe8ffffffe8
> > [    4.966905]  0000001800000000 ffffffff81162980 0000000000000018 ffffff0000441f0f
> > [    4.966907] Call Trace:
> > [    4.966912]  [<ffffffff810542e0>] ? poke_int3_handler+0x40/0x40
> > [    4.966916]  [<ffffffff816a0cf3>] dump_stack+0x59/0x7b
> > [    4.966920]  [<ffffffff81051e0a>] __jump_label_transform+0x18a/0x230
> > [    4.966923]  [<ffffffff81162980>] ? fire_user_return_notifiers+0x70/0x70
> > [    4.966926]  [<ffffffff81051f15>] arch_jump_label_transform_static+0x65/0x90
> > [    4.966930]  [<ffffffff81cfbbfb>] jump_label_init+0x75/0xa3
> > [    4.966932]  [<ffffffff81cd3e3c>] start_kernel+0x168/0x3ff
> > [    4.966934]  [<ffffffff81cd3af2>] ? repair_env_string+0x5b/0x5b
> > [    4.966938]  [<ffffffff81cd35f3>] x86_64_start_reservations+0x2a/0x2c
> > [    4.966941]  [<ffffffff81cd833a>] xen_start_kernel+0x594/0x596
> > [    4.967072] PID hash table entries: 4096 (order: 3, 32768 bytes)
> > [    5.009945] software IO TLB [mem 0x3a400000-0x3e400000] (64MB) mapped at [ffff88003a400000-ffff88003e3fffff]
> > [    5.013794] Memory: 868480K/1048572K available (6860K kernel code, 752K rwdata, 2140K rodata, 1708K init, 1876K bss, 180092K reserved)
> > [    5.014212] Hierarchical RCU implementation.
> > [    5.014214] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
> > [    5.014229] NR_IRQS:33024 nr_irqs:712 16
> > [    5.014370] xen: sci override: global_irq=9 trigger=0 polarity=1
> > 
> > .... snip.
> > 
> > And here is the patch:
> > 
> > diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> > index ee11b7d..e3a41a0 100644
> > --- a/arch/x86/kernel/jump_label.c
> > +++ b/arch/x86/kernel/jump_label.c
> > @@ -44,13 +44,31 @@ static void __jump_label_transform(struct jump_entry *entry,
> >  	union jump_code_union code;
> >  	const unsigned char *ideal_nop = ideal_nops[NOP_ATOMIC5];
> >  
> > +	if (init) {
> > +		const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
> > +		if (unlikely(memcmp((void *)entry->code, default_nop, 5) != 0))
> > +			bug_at((void *)entry->code, __LINE__);
> > +	}
> >  	if (type == JUMP_LABEL_ENABLE) {
> >  		/*
> >  		 * We are enabling this jump label. If it is not a nop
> >  		 * then something must have gone wrong.
> >  		 */
> > -		if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0))
> > -			bug_at((void *)entry->code, __LINE__);
> > +		if (init) {
> > +			if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0)) {
> > +				static int log = 0;
> > +
> > +				if (log == 0) {
> > +					pr_warning("op %pS\n", (void *)entry->code);
> > +					dump_stack();
> 
> OK, I think I understand the problem, and this may or may not be a real
> bug depending on what the jump label infrastructure expects.
> 
> Jason,
> 
> How safe is it to use static_key_slow_inc() before jump_label_init() is
> called?
> 
> What happened here is that the xen code called by
> smp_prepare_boot_cpu() checks boot parameters and may do a
> static_key_slow_inc() if xen_nopvspin is not set. Which basically
> enables a jump label. The issues is that because jump_labels have not
> been initialized yet, it just ups the "enable" count and does not
> modify anything because key->entries is still NULL.
> 
> When jump_label_init() is called, it sees that the branch is enabled
> and then converts it to being enabled, but here's where the current
> check fails. It does not expect a jump label to be already enabled when
> it gets here.
> 
> Now, if it is fine to enable a jump label before jump_label_init() then
> I will agree that this patch is the proper fix. But before I give my
> Ack, I want to know if the jump label infrastructure was designed to
> allow enabling of jump labels at boot up before jump_label_init() is
> run.

This patch:

commit 97ce2c88f9ad42e3c60a9beb9fca87abf3639faa
Author: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date:   Wed Oct 12 16:17:54 2011 -0700

    jump-label: initialize jump-label subsystem much earlier
    
    Initialize jump_labels much, much earlier, so they're available for use
    during system setup.
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


implies that yes.
