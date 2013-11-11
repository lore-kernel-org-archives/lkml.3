Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3KKT51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:57:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab3KKT5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:57:19 -0500
Date: Mon, 11 Nov 2013 20:58:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Cleanup !CONFIG_UPROBES decls, unexport
	xol_area
Message-ID: <20131111195836.GA20615@redhat.com>
References: <20131109190344.GA32281@redhat.com> <20131111084149.GC12405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111084149.GC12405@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > +++ b/kernel/events/uprobes.c
> > @@ -86,6 +86,25 @@ struct return_instance {
> >  };
> >
> >  /*
> > + * On a breakpoint hit, thread contests for a slot.  It frees the
> > + * slot after singlestep. Currently a fixed number of slots are
> > + * allocated.
> > + */
> > +struct xol_area {
>
> So, my main complaint about the uprobes code isn't functional but
> documentational, similar to what I outlined a few days ago: what this
> comment does not explain is exactly what a 'XOL area' is.
>
> You guys are changing code that reads like gobbledygook to people reading
> it for the first time.

Not that I am trying to defense uprobes, but this is equally true for
any piece of kernel code, at least to me ;)

> It's understandable that you want to use
> abbreviations and I don't object against that, but please explain key
> concepts and data structures when they first come up

Well, this patch only move the definition with the comments, but:

> - a very good place
> to do that is in places where key structures are declared.
>
> I didn't find any high level description of the XOL code, one which makes
> clear that how we manage these out of line execution areas:

I have to agree, all these comments do not really help...

> The one that comes closest is:
>
>           * This area will be used for storing instructions for execution out of line.
>
> ... but that is a single sentence and deep inside the XOL code already.

and even this comment should be probably moved up to the "struct xol_area",


> Really, please make a better job of introducing other kernel hackers to
> the code you are writing ...
>
> Maybe even split the XOL code out into kernel/events/uprobes_xol.c or so?

I do not really think a separate uprobes_xol.c makes sense. I think it would
be nice to have the high-level "uprobes design" doc in uprobetracer.txt, or

> That will give a natural place to explain yourselves at the beginning of
> the file.

or even in the beginning of uprobes.c, I agree.

Don't get me wrong, I am not volunteering ;) But at least I'll try to
pay more attention to the comments when I change the code next time.

Oleg.

