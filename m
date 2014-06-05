Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaFERpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:45:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaFERpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:45:35 -0400
Date: Thu, 5 Jun 2014 10:49:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Rob Clark <robdclark@gmail.com>, Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fence: Use smp_mb__before_atomic()
Message-ID: <20140605174916.GA3433@kroah.com>
References: <1401287192-14701-1-git-send-email-thierry.reding@gmail.com>
 <20140528205145.GB10468@kroah.com>
 <20140530081504.GA16669@ulmo>
 <20140530160831.GA11182@kroah.com>
 <CAO_48GE_Y7DQj_nCZ=0gb_AY26_vtPsQybf9zuhsLW1nnaOuQw@mail.gmail.com>
 <20140604132831.GC28484@ulmo>
 <20140604174902.GC20812@kroah.com>
 <CAF6AEGuaURm-AHHh6G=HnJYFLUWBhPOxKaBQCqn-=-9CQdKe8w@mail.gmail.com>
 <20140605154831.GA23993@kroah.com>
 <CAO_48GFfFFqqMuR0Vgg4=4zsPmJ2GOBpt=P2ZTNnYOKv8sGnrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_48GFfFFqqMuR0Vgg4=4zsPmJ2GOBpt=P2ZTNnYOKv8sGnrA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 10:09:29PM +0530, Sumit Semwal wrote:
> Hi Greg,
> 
> On 5 June 2014 21:18, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >> > But again, why is the fence.c code needed at all anyway?  I'm not sold
> >> > on that.
> >>
> >> Fence serves as a way to synchronize between (for example) multiple
> >> asynchronous gpu's.  There is definitely a need for this.  Otherwise
> >> performance for optimus/prime type setups is going to suck.
> >
> > What's wrong with the 'sync' code in the drivers/staging/android/
> > directory?  I thought that is what that codebase was supposed to be
> > doing.
> >
> (Just a quick recap on sync v/s fences):
> Well, there was a discussion on Sync v/s Fences at LPC 2013 [1], and
> the agreement was that if (explicit) sync could be implemented on top
> of (implicitly synchronized) fences, fences might provide more
> flexibility.
> Maarten implemented that (it is a part of this patch series), and
> Android guys confirmed that it worked the same way as expected in the
> Android system. That is a major reason for acceptance of fence as the
> solution.

That's great to hear, again, it should have been conveyed somehow :)

> >> I thought we had added something under Documentation/ about it, but I
> >> can't find it now (although possibly looking at the wrong trees)..
> >> there is at least a bit of a description in the commit msg:
> >>
> >>   https://lkml.org/lkml/2014/2/24/602
> >
> > Ah, so no documenation, no discussion, and you want to just throw it in
> > a directory I am responsible for?  That sounds like a major rush job...
> >
> While I totally agree that it was an honest mistake to not have you
> notified in CC for the patch series, for your other observations,
> please allow me to answer one-by-one:
>  (1) No documentation: there is in-code documentation which is also
> added to Documentation/DocBook/device-drivers.tmpl; the commit message
> has a lot of description about it. Of course, it could do with its own
> documentation as well.
>  (2) No discussion: the patch series is into v17 - v2 was posted in
> July 2012, so it does seem like it has gone through a series of
> reviews - I would admit that it has been mostly limited to the people
> it seemed to matter the most for - the dri-devel and v4l communities.

Limiting the discussion to the people involved is fine, and great, but
really, for a core kernel function, you need to pull in _some_ core
kernel people to at least go over the api.

With just a quick glance, I already had api objections to how you were
implementing things, those should be addressed at the least before the
code is merged.

> >> I don't think the question about whether we need something like fence
> >> to augment dma-buf is really in doubt.  Maybe it should live somewhere
> >> else, I'm not sure.  But it makes sense for it to live wherever
> >> dma-buf does, as they are intended to work together.
> >
> > Ok, then let's give it a proper review cycle, and notify everyone
> > involved.  It doesn't look like this happened at all.  We don't add core
> > primitives to the kernel without a lot of discussion and agreement.  And
> > we sure don't add them without telling the person who owns the directory
> > (again, my pet peeve, I know...)
> >
> And again, I do apologize that we all missed the fact that you weren't
> CC'ed onto the patch series.
> 
> Still, even in the wake of above information, if you feel we are not
> ready to take it for 3.16, I would drop it from my queue for 3.16
> (though there are quite a few people who've waited long for this to
> land in).

Given that I have yet to even be cc:ed on a patch, and the merge window
is 1 week in, _and_ people are still discussing where to put the files,
yes, it's too late for 3.16, sorry.

Please feel free to respin and resend after 3.16-rc1 is out.  There is
no "deadline" here that is requiring code to ever be merged.  We do
things correctly, not rushed.

thanks,

greg k-h
