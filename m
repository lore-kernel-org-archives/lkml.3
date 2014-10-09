Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbaJINP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:15:28 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:58316 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJINPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:15:20 -0400
Date: Thu, 9 Oct 2014 09:15:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the percpu tree with the tip tree
Message-ID: <20141009131512.GB14387@htj.dyndns.org>
References: <20141009155018.0b8f26f6@canb.auug.org.au>
 <20141009131328.GB25790@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009131328.GB25790@lerouge>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 03:13:31PM +0200, Frederic Weisbecker wrote:
> On Thu, Oct 09, 2014 at 03:50:18PM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the percpu tree got a conflict in
> > kernel/irq_work.c between commit 76a33061b932 ("irq_work: Force raised
> > irq work to run on irq work interrupt") from the tip tree and commit
> > 22127e93c587 ("time: Replace __get_cpu_var uses") from the percpu tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
> > 
> > -- 
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > 
> > diff --cc kernel/irq_work.c
> > index 385b85aded19,345d19edcdae..000000000000
> > --- a/kernel/irq_work.c
> > +++ b/kernel/irq_work.c
> > @@@ -113,12 -113,10 +113,12 @@@ bool irq_work_needs_cpu(void
> >   {
> >   	struct llist_head *raised, *lazy;
> >   
> > - 	raised = &__get_cpu_var(raised_list);
> > - 	lazy = &__get_cpu_var(lazy_list);
> > + 	raised = this_cpu_ptr(&raised_list);
> > + 	lazy = this_cpu_ptr(&lazy_list);
> 
> Ah thanks! The conflict is compile time rather than merge time, thanks
> for spotting it!
> 
> Should we notify Linus about it? That's certainly something that should
> be applied with the percpu tree.

I'm holding back percpu/for-3.18-consistent-ops till other trees are
merged and collecting the conflicts.  I'll list them when sending the
pull request.

Thanks.

-- 
tejun
