Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3IKRFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:05:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22578 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3IKRFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:05:09 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=cpn0iEa-oVMA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=uXgjhyO7DfoA:10 a=yPCof4ZbAAAA:8 a=vSx4xfTMZCQdpJUK1gYA:9 a=CjuIK1q_8ugA:10 a=7DSvI1NPTFQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 13:05:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@akamai.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Subject: Re: Regression :-) Re: [GIT PULL RESEND] x86/jumpmplabel changes
 for v3.12-rc1
Message-ID: <20130911130507.44a2b115@gandalf.local.home>
In-Reply-To: <20130911161745.GA5884@phenom.dumpdata.com>
References: <201309110248.r8B2miI2032449@terminus.zytor.com>
	<20130911134717.GA10925@phenom.dumpdata.com>
	<20130911135745.GB11043@phenom.dumpdata.com>
	<20130911142545.GA11364@phenom.dumpdata.com>
	<20130911105633.1c029147@gandalf.local.home>
	<20130911152149.GA22076@phenom.dumpdata.com>
	<20130911114708.1b42aec0@gandalf.local.home>
	<20130911161745.GA5884@phenom.dumpdata.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Fixed Jason Baron's email so that he can join the conversation ]

On Wed, 11 Sep 2013 12:17:45 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Wed, Sep 11, 2013 at 11:47:08AM -0400, Steven Rostedt wrote:

> [    4.966101] Kernel command line: debug selinux=0 earlyprintk=xen console=hvc0 xencons=hvc0 loglevel=10 pci=resource_alignment=00:13.2 xen-pciback.hide=(08:07.0)(08:06.0)(00:12.0)(00:12.1)(00:12.2)(00:13.0)(00:13.1)(00:13.2)(00:14.5) xen-pciback.passthrough=0
> [    4.966892] op trace_clock_global+0x6b/0x120
> [    4.966895] CPU: 0 PID: 0 Comm: swapper Not tainted 3.11.0upstream-09031-ga22a0fd-dirty #1
> [    4.966897] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080014  07/18/2008
> [    4.966899]  ffffffff810542e0 ffffffff81c01e28 ffffffff816a0cf3 0000000000000001
> [    4.966903]  ffffffff81ca8598 ffffffff81c01e88 ffffffff81051e0a ffffffe8ffffffe8
> [    4.966905]  0000001800000000 ffffffff81162980 0000000000000018 ffffff0000441f0f
> [    4.966907] Call Trace:
> [    4.966912]  [<ffffffff810542e0>] ? poke_int3_handler+0x40/0x40
> [    4.966916]  [<ffffffff816a0cf3>] dump_stack+0x59/0x7b
> [    4.966920]  [<ffffffff81051e0a>] __jump_label_transform+0x18a/0x230
> [    4.966923]  [<ffffffff81162980>] ? fire_user_return_notifiers+0x70/0x70
> [    4.966926]  [<ffffffff81051f15>] arch_jump_label_transform_static+0x65/0x90
> [    4.966930]  [<ffffffff81cfbbfb>] jump_label_init+0x75/0xa3
> [    4.966932]  [<ffffffff81cd3e3c>] start_kernel+0x168/0x3ff
> [    4.966934]  [<ffffffff81cd3af2>] ? repair_env_string+0x5b/0x5b
> [    4.966938]  [<ffffffff81cd35f3>] x86_64_start_reservations+0x2a/0x2c
> [    4.966941]  [<ffffffff81cd833a>] xen_start_kernel+0x594/0x596
> [    4.967072] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    5.009945] software IO TLB [mem 0x3a400000-0x3e400000] (64MB) mapped at [ffff88003a400000-ffff88003e3fffff]
> [    5.013794] Memory: 868480K/1048572K available (6860K kernel code, 752K rwdata, 2140K rodata, 1708K init, 1876K bss, 180092K reserved)
> [    5.014212] Hierarchical RCU implementation.
> [    5.014214] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
> [    5.014229] NR_IRQS:33024 nr_irqs:712 16
> [    5.014370] xen: sci override: global_irq=9 trigger=0 polarity=1
> 
> .... snip.
> 
> And here is the patch:
> 
> diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> index ee11b7d..e3a41a0 100644
> --- a/arch/x86/kernel/jump_label.c
> +++ b/arch/x86/kernel/jump_label.c
> @@ -44,13 +44,31 @@ static void __jump_label_transform(struct jump_entry *entry,
>  	union jump_code_union code;
>  	const unsigned char *ideal_nop = ideal_nops[NOP_ATOMIC5];
>  
> +	if (init) {
> +		const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
> +		if (unlikely(memcmp((void *)entry->code, default_nop, 5) != 0))
> +			bug_at((void *)entry->code, __LINE__);
> +	}
>  	if (type == JUMP_LABEL_ENABLE) {
>  		/*
>  		 * We are enabling this jump label. If it is not a nop
>  		 * then something must have gone wrong.
>  		 */
> -		if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0))
> -			bug_at((void *)entry->code, __LINE__);
> +		if (init) {
> +			if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0)) {
> +				static int log = 0;
> +
> +				if (log == 0) {
> +					pr_warning("op %pS\n", (void *)entry->code);
> +					dump_stack();

OK, I think I understand the problem, and this may or may not be a real
bug depending on what the jump label infrastructure expects.

Jason,

How safe is it to use static_key_slow_inc() before jump_label_init() is
called?

What happened here is that the xen code called by
smp_prepare_boot_cpu() checks boot parameters and may do a
static_key_slow_inc() if xen_nopvspin is not set. Which basically
enables a jump label. The issues is that because jump_labels have not
been initialized yet, it just ups the "enable" count and does not
modify anything because key->entries is still NULL.

When jump_label_init() is called, it sees that the branch is enabled
and then converts it to being enabled, but here's where the current
check fails. It does not expect a jump label to be already enabled when
it gets here.

Now, if it is fine to enable a jump label before jump_label_init() then
I will agree that this patch is the proper fix. But before I give my
Ack, I want to know if the jump label infrastructure was designed to
allow enabling of jump labels at boot up before jump_label_init() is
run.

-- Steve




> +				}
> +				log++;
> +			}
> +		}
> +		if (!init) {
> +			if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0))
> +				bug_at((void *)entry->code, __LINE__);
> +		}
>  
>  		code.jump = 0xe9;
>  		code.offset = entry->target -
> @@ -62,11 +80,7 @@ static void __jump_label_transform(struct jump_entry *entry,
>  		 * If this is the first initialization call, then we
>  		 * are converting the default nop to the ideal nop.
>  		 */
> -		if (init) {
> -			const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
> -			if (unlikely(memcmp((void *)entry->code, default_nop, 5) != 0))
> -				bug_at((void *)entry->code, __LINE__);
> -		} else {
> +		if (!init) {
>  			code.jump = 0xe9;
>  			code.offset = entry->target -
>  				(entry->code + JUMP_LABEL_NOP_SIZE);

