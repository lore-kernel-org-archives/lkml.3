Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533Ab3GPAIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:08:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42771 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755085Ab3GPAIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:08:07 -0400
X-Sasl-enc: 9UIDQuYmSgSVu+EQh1NDUzY6nbnOGcwyi6hlA24+GNOp 1373933283
Date: Mon, 15 Jul 2013 16:59:56 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
Message-ID: <20130715235956.GA26261@kroah.com>
References: <1373916476.2748.69.camel@dabdike>
 <20130715214422.GA2478@kroah.com>
 <alpine.LNX.2.00.1307160011530.29788@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1307160011530.29788@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 12:22:16AM +0200, Jiri Kosina wrote:
> On Mon, 15 Jul 2013, Greg KH wrote:
> 
> > > The solution, to me, looks simple:  Let's co-opt a process we already
> > > know how to do: mailing list review and tree handling.  So the proposal
> > > is simple:
> > > 
> > >      1. Drop the cc: stable@ tag: it makes it way too easy to add an ill
> > >         reviewed patch to stable
> > >      2. All patches to stable should follow current review rules: They
> > >         should go to the mailing list the original patch was sent to
> > >         once the original is upstream as a request for stable.
> > >      3. Following debate on the list, the original maintainer would be
> > >         responsible for collecting the patches (including the upstream
> > >         commit) adjudicating on them and passing them on to stable after
> > >         list review (either by git tree pull or email to stable@).
> > > 
> > > I contend this raises the bar for adding patches to stable much higher,
> > > which seems to be needed, and adds a review stage which involves all the
> > > original reviewers.
> > 
> > I don't like this at all, just for the simple reason that it will push
> > the majority of the work of stable kernel development on to the
> > subsystem maintainers, who have enough work to do as it is.
> 
> Sorry Greg, but I disagree.
> 
> If the point of the stable tree really is about rock-solid stability, the 
> "it applies without fuzz and there was no explicit NACK" just isn't 
> enough. Someone who actually understands the code (maintainer) should 
> absolutely give his Acked-for-stable-by: (*), otherwise the result is much 
> less trustworthy.
> 
> I think 991f76f83 might serve as a good example. It has been marked "Cc: 
> stable", it applied without cleanly, so it has been applied to all the 
> existing stable trees, including 3.0.
> 
> The problem is that one has to actually perform a review of the patch with 
> respect to 3.0.x codebase to notice that the pre-requisity for this patch 
> (ef3d0fd27e) is only present in 3.2 and later, and hasn't been marked for 
> stable (which is correct, it has no business there).

Ok, that's a bug / fault that was my fault.  It got caught (right?),
that will always happen at times, all we can do is recover and move on.

And you really did want this patch in the stable kernel at the time, as
it could crash the kernel, so no matter what the procedure in place
was, I would have applied it.  Heck, I am the maintainer there, so I
messed up, how could I have prevented myself from applying the patch?  :)

> (*) For me personally, the best mode of operation would actually be to 
>     have for-stable/3.x branches in my git tree, cherry-pick from other 
>     topic branches once the patches are in Linus' tree, and send you pull 
>     request for stable regularly (for each stable branch separately of 
>     course)
>    
>     This model would make maintainers clearly responsible for the contents 
>     of stable tree, wouldn't cause any extra work for you (quite the 
>     contrary, I'd say), and it'd follow the development model we have for
>     Linus' tree.

I don't object to that, and again, some maintainers do this.  If you
want to do this for your trees, fine with me.  But for others, it might
not be the best workflow.

It also increases the workload on maintainers to support stable
releases, which is what I do _not_ want to do at all.  Maintainers are
the most limited of resources that we possibly have at the moment, I
will almost never ask them to do extra work that is not needed.

thanks,

greg k-h
