Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaIWGVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:21:37 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:34342 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaIWGVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:21:36 -0400
X-Originating-IP: 50.43.15.134
Date: Mon, 22 Sep 2014 23:21:25 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: linux-next: manual merge of the tiny tree with the tip tree
Message-ID: <20140923062125.GB6900@thin>
References: <20140923143232.5ffff46e@canb.auug.org.au>
 <20140923054328.GA28790@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923054328.GA28790@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 07:43:28AM +0200, Ingo Molnar wrote:
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Today's linux-next merge of the tiny tree got conflicts in
> > arch/x86/kernel/process_32.c and arch/x86/kernel/process_64.c between
> > commits dc56c0f9b870 ("x86, fpu: Shift "fpu_counter = 0" from
> > copy_thread() to arch_dup_task_struct()") and 6f46b3aef003 ("x86:
> > copy_thread: Don't nullify ->ptrace_bps twice") from the tip tree and
> > commits a1cf09f93e66 ("x86: process: Unify 32-bit and 64-bit
> > copy_thread I/O bitmap handling") and e4a191d1e05b ("x86: Support
> > compiling out userspace I/O (iopl and ioperm)") from the tiny tree.
> 
> Why are such changes in the 'tiny' tree? These are sensitive 
> arch/x86 files, and any unification and compilation-out support 
> patches need to go through the proper review channels and be 
> merged upstream via the x86 tree if accepted...
> 
> In particular the graticious sprinking of #ifdef 
> CONFIG_X86_IOPORTs around x86 code looks ugly.
> 
> Josh, don't do that, this route is really unacceptable. Please 
> resubmit the latest patches and remove these from linux-next.

I'd previously submitted these patches for review; the last round of
feedback seemed entirely positive (with some explicit acks) on the 32/64
unification patches, and generally positive on the last patch of the
series (apart from a misunderstanding about this being configurable but
still default y).  I CCed you on that submission, and hadn't seen any of
this feedback from you at that time (nor a suggestion of which tree this
should go through).  My intention with adding these patches to tiny/next
tree was purely for an integration check with -next, and I'd planned to
resend these by email shortly for an additional round of review with an
explicit question of what route they should take into the kernel.

I've dropped tiny/no-io from tiny/next; I'll poke at it further and
resubmit for the x86 tree later, likely not for the next merge window at
this point.

Thanks for the feedback on process; this is day 1 of having a
merge-window-bound tree in -next for the first time. :)

- Josh Triplett
