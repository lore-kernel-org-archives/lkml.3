Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbaIWIgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:36:11 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34709 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbaIWIgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:36:08 -0400
Date: Tue, 23 Sep 2014 10:36:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: linux-next: manual merge of the tiny tree with the tip tree
Message-ID: <20140923083603.GA31876@gmail.com>
References: <20140923143232.5ffff46e@canb.auug.org.au>
 <20140923054328.GA28790@gmail.com>
 <20140923062125.GB6900@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923062125.GB6900@thin>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Triplett <josh@joshtriplett.org> wrote:

> On Tue, Sep 23, 2014 at 07:43:28AM +0200, Ingo Molnar wrote:
> > * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > Today's linux-next merge of the tiny tree got conflicts in
> > > arch/x86/kernel/process_32.c and arch/x86/kernel/process_64.c between
> > > commits dc56c0f9b870 ("x86, fpu: Shift "fpu_counter = 0" from
> > > copy_thread() to arch_dup_task_struct()") and 6f46b3aef003 ("x86:
> > > copy_thread: Don't nullify ->ptrace_bps twice") from the tip tree and
> > > commits a1cf09f93e66 ("x86: process: Unify 32-bit and 64-bit
> > > copy_thread I/O bitmap handling") and e4a191d1e05b ("x86: Support
> > > compiling out userspace I/O (iopl and ioperm)") from the tiny tree.
> > 
> > Why are such changes in the 'tiny' tree? These are sensitive 
> > arch/x86 files, and any unification and compilation-out support 
> > patches need to go through the proper review channels and be 
> > merged upstream via the x86 tree if accepted...
> > 
> > In particular the graticious sprinking of #ifdef 
> > CONFIG_X86_IOPORTs around x86 code looks ugly.
> > 
> > Josh, don't do that, this route is really unacceptable. Please 
> > resubmit the latest patches and remove these from linux-next.
> 
> I'd previously submitted these patches for review; the last 
> round of feedback seemed entirely positive (with some explicit 
> acks) on the 32/64 unification patches, and generally positive 
> on the last patch of the series (apart from a misunderstanding 
> about this being configurable but still default y).  I CCed you 
> on that submission, and hadn't seen any of this feedback from 
> you at that time (nor a suggestion of which tree this should go 
> through).  My intention with adding these patches to tiny/next 
> tree was purely for an integration check with -next, and I'd 
> planned to resend these by email shortly for an additional 
> round of review with an explicit question of what route they 
> should take into the kernel.

That's perfectly fine, thanks!

> I've dropped tiny/no-io from tiny/next; I'll poke at it further 
> and resubmit for the x86 tree later, likely not for the next 
> merge window at this point.
> 
> Thanks for the feedback on process; this is day 1 of having a 
> merge-window-bound tree in -next for the first time. :)

Sorry about the harshness of my initial email - I was unsure 
about the background and we are close to the merge window. I have 
no objections against the -tiny tree in linux-next, it's a good 
effort.

I think we could cut down on the #ifdef uglies if we made the 
ioperm callback pointer unconditional. That's just a tiny amount 
of extra bloat, but should remove half of the #ifdefs or so? The 
rest of the patches look fine.

Usually hpa handles the x86 ioperm area, but he's swamped right 
now, so I'll look at picking them up once you have submitted the 
latest version. If you send it in the next day or two then they 
could make the v3.18 merge window.

Thanks,

	Ingo
