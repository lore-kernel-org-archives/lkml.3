Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaFDRoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:44:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaFDRoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:44:23 -0400
Date: Wed, 4 Jun 2014 10:48:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fence: Use smp_mb__before_atomic()
Message-ID: <20140604174803.GB20812@kroah.com>
References: <1401287192-14701-1-git-send-email-thierry.reding@gmail.com>
 <20140528205145.GB10468@kroah.com>
 <20140530081504.GA16669@ulmo>
 <20140530160831.GA11182@kroah.com>
 <CAO_48GE_Y7DQj_nCZ=0gb_AY26_vtPsQybf9zuhsLW1nnaOuQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_48GE_Y7DQj_nCZ=0gb_AY26_vtPsQybf9zuhsLW1nnaOuQw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 04:57:07PM +0530, Sumit Semwal wrote:
> Hi Greg,
> 
> 
> On 30 May 2014 21:38, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > On Fri, May 30, 2014 at 10:15:05AM +0200, Thierry Reding wrote:
> >> On Wed, May 28, 2014 at 01:51:45PM -0700, Greg Kroah-Hartman wrote:
> >> > On Wed, May 28, 2014 at 04:26:32PM +0200, Thierry Reding wrote:
> >> > > From: Thierry Reding <treding@nvidia.com>
> >> > >
> >> > > Commit febdbfe8a91c (arch: Prepare for smp_mb__{before,after}_atomic())
> >> > > deprecated the smp_mb__{before,after}_{atomic,clear}_{dec,inc,bit}*()
> >> > > functions in favour of the unified smp_mb__{before,after}_atomic().
> >> > >
> >> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> >> > > ---
> >> > >  drivers/base/fence.c | 4 ++--
> >> >
> >> > Where does this file come from?  I've not seen it before, and it's not
> >> > in my tree.
> >>
> >> I think it came in through Sumit's tree and it's only in linux-next I
> >> believe.
> >
> > Odd, linux-next is for merging things in Linus's next release.
> >
> > And as I have never seen this code that will end up being my
> > responsibility to maintain, it seems strange that it will be merged in
> > the next kernel development cycle.
> >
> > What broke down here with our review process that required something to
> > be merged without at least a cc: to me?
> 
> This is a new file added by Maarten's patches [1], that got reviewed
> on dri-devel and other mailing lists. Since it was quite closely
> associated with dma-buf, I figured I should take it through the
> dma-buf tree.
> 
> I am sorry I didn't notice that you weren't CC'ed on these patches -
> Sincere apologies, since I should've noticed that during the patch
> review process - I would take part of the blame here as well  :(
> 
> I do realize now that atleast on my part, I should've asked you before
> taking it through the dma-buf tree - I will make sure things like this
> don't happen again through me.
> 
> May I request you to help us handle this - would it help if we add
> Maarten as the maintainer for this file? Any other suggestions?

I'd prefer the fence.c file not be in the driver core at all for now as
it doesn't follow the rules for other files in that directory (symbol
exports, __functions that are global, config option for no good reason,
etc.)

Any chance you can just drop these and go through another review cycle?
I'm not sold on even why this file is needed at all, and that our
current kernel primitives don't work instead.

Doubly good reason is that you, or someone, is assuming that I was
going to maintain this...

So, care to drop the series and have Maarten resend?

thanks,

greg k-h
