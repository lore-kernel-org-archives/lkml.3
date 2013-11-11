Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3KKVDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:03:38 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:36947 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3KKVDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:03:31 -0500
Date: Mon, 11 Nov 2013 22:03:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Cleanup !CONFIG_UPROBES decls, unexport xol_area
Message-ID: <20131111210327.GG18886@gmail.com>
References: <20131109190344.GA32281@redhat.com>
 <20131111084149.GC12405@gmail.com>
 <20131111195836.GA20615@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111195836.GA20615@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 11/11, Ingo Molnar wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > +++ b/kernel/events/uprobes.c
> > > @@ -86,6 +86,25 @@ struct return_instance {
> > >  };
> > >
> > >  /*
> > > + * On a breakpoint hit, thread contests for a slot.  It frees the
> > > + * slot after singlestep. Currently a fixed number of slots are
> > > + * allocated.
> > > + */
> > > +struct xol_area {
> >
> > So, my main complaint about the uprobes code isn't functional but 
> > documentational, similar to what I outlined a few days ago: what this 
> > comment does not explain is exactly what a 'XOL area' is.
> >
> > You guys are changing code that reads like gobbledygook to people 
> > reading it for the first time.
> 
> Not that I am trying to defense uprobes, but this is equally true for 
> any piece of kernel code, at least to me ;)

I'm really not suggesting to do overly much - only for some minimal blurb 
like the scheduler has in most places:

/*
 * This is the main, per-CPU runqueue data structure.
 *
 * Locking rule: those places that want to lock multiple runqueues
 * (such as the load balancing or the thread migration code), lock
 * acquire operations must be ordered by ascending &runqueue.
 */
struct rq {
        /* runqueue lock: */
        raw_spinlock_t lock;

But the apparent assumption that the reader knows what 'XOL' means 
triggered my suggest :-)

> > Maybe even split the XOL code out into kernel/events/uprobes_xol.c or 
> > so?
> 
> I do not really think a separate uprobes_xol.c makes sense. [...]

Ok - it's your call really.

> [...] I think it would be nice to have the high-level "uprobes design" 
> doc in uprobetracer.txt, or

Even better if the best parts are integrated into the source code!

Thanks,

	Ingo
